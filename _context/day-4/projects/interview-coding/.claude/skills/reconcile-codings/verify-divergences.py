#!/usr/bin/env python3
"""
verify-divergences.py - deterministic divergence detector for the
/reconcile-codings skill.

Given a directory of per-coder coding CSVs and the interview transcripts, this
script does the reproducible, non-interpretive half of a coder-alignment audit:

  1. PROVENANCE  - confirms every coded excerpt is verbatim in its transcript.
  2. LOCATION    - groups coded segments by (respondent_id, line).
  3. OVERLAP     - for segments that share a location, measures how much the
                   coders' chosen excerpts overlap. Excerpts do NOT have to be
                   identical: overlap is scored by character-range containment
                   within the transcript line, and --overlap-threshold sets
                   how much counts as "the same stretch of talk."
  4. CLASSIFY    - labels every location convergent / code-divergent /
                   coverage-divergent, and reports the SHAPE of each split
                   (unanimous, N-1 lone holdout, K-way scatter).

It deliberately stops there. It does not diagnose a divergence as D1/D2/D3 and
does not propose resolutions - that interpretive work belongs to the skill. The
script's output is the deterministic ledger the skill reasons on top of, and
which anyone can re-run to verify a memo's divergence list.

Usage (run from the project root):
    python3 .claude/skills/reconcile-codings/verify-divergences.py
    python3 .../verify-divergences.py --codings inputs/analysis --json

Exit status: 0 if every excerpt passed provenance, 1 otherwise.
Standard library only; no third-party dependencies.
"""
import argparse
import csv
import json
import os
import re
import sys
from collections import defaultdict

# Tolerant column detection: canonical name -> accepted header variants.
CANON = {
    "respondent_id": ["respondent_id", "respondent", "rid"],
    "line": ["line", "transcript_line", "ln", "line_number"],
    "code": ["code", "open_code", "theme"],
    "excerpt": ["excerpt", "quote", "data_extract", "text"],
    "coder": ["coder", "coder_id", "rater"],
    "confidence": ["confidence", "certainty"],
    "segment_id": ["segment_id", "id", "excerpt_id", "seg_id"],
    "memo": ["memo", "note", "coder_note", "interpretive_memo", "analytic_memo"],
}


def detect_columns(fieldnames):
    norm = {(f or "").lower().strip(): f for f in (fieldnames or [])}
    out = {}
    for canon, variants in CANON.items():
        for v in variants:
            if v in norm:
                out[canon] = norm[v]
                break
    return out


def parse_line_number(raw):
    m = re.search(r"\d+", raw or "")
    return int(m.group()) if m else None


def norm_ws(s):
    return re.sub(r"\s+", " ", s or "").strip()


# -- span geometry (character ranges within a transcript line) ---------------

def intersection(a, b):
    if not a or not b:
        return 0
    return max(0, min(a[1], b[1]) - max(a[0], b[0]))


def containment(a, b):
    """Overlap coefficient: intersection / shorter span. 1.0 if one span
    fully contains the other - the right measure for 'are these two excerpts
    about the same stretch of talk' when the excerpts are different lengths."""
    if not a or not b:
        return 0.0
    inter = intersection(a, b)
    if inter == 0:
        return 0.0
    return inter / min(a[1] - a[0], b[1] - b[0])


# -- loading -----------------------------------------------------------------

def load_transcripts(tdir):
    transcripts = {}
    for fn in sorted(os.listdir(tdir)):
        m = re.match(r"(R\d+)", fn)
        if m and fn.endswith(".md"):
            with open(os.path.join(tdir, fn), encoding="utf-8") as f:
                transcripts[m.group(1)] = {"file": fn, "lines": f.read().splitlines()}
    return transcripts


def load_codings(cdir):
    segments, warnings = [], []
    for fn in sorted(os.listdir(cdir)):
        if not fn.endswith(".csv"):
            continue
        with open(os.path.join(cdir, fn), encoding="utf-8") as f:
            reader = csv.DictReader(f)
            cols = detect_columns(reader.fieldnames)
            missing = [k for k in ("respondent_id", "line", "code", "excerpt")
                       if k not in cols]
            if missing:
                warnings.append(f"{fn}: missing required column(s) {missing}; file skipped")
                continue
            file_coder = os.path.splitext(fn)[0]
            for i, row in enumerate(reader, start=2):
                coder = (row.get(cols["coder"]) or "").strip() if "coder" in cols else ""
                segments.append({
                    "coder": coder or file_coder,
                    "file": fn,
                    "segment_id": (row.get(cols["segment_id"]) or "").strip()
                                  if "segment_id" in cols else f"{fn}:{i}",
                    "respondent_id": (row[cols["respondent_id"]] or "").strip(),
                    "line": parse_line_number(row[cols["line"]]),
                    "code": (row[cols["code"]] or "").strip(),
                    "excerpt": row[cols["excerpt"]] or "",
                    "confidence": (row.get(cols["confidence"]) or "").strip()
                                  if "confidence" in cols else "",
                    "memo": (row.get(cols["memo"]) or "").strip()
                            if "memo" in cols else "",
                })
    return segments, warnings


# -- provenance --------------------------------------------------------------

def check_provenance(segments, transcripts):
    """Locate each excerpt in its transcript; record status and the character
    span it occupies within its line. Mutates segments in place."""
    for s in segments:
        s["status"], s["span"] = "NOT_FOUND", None
        t = transcripts.get(s["respondent_id"])
        if not t or not s["line"]:
            continue
        lines = t["lines"]
        if 1 <= s["line"] <= len(lines):
            line_text = lines[s["line"] - 1]
            idx = line_text.find(s["excerpt"])
            if idx >= 0:
                s["status"], s["span"] = "OK", (idx, idx + len(s["excerpt"]))
                continue
            if norm_ws(s["excerpt"]) and norm_ws(s["excerpt"]) in norm_ws(line_text):
                s["status"] = "OK_WHITESPACE"  # verbatim up to whitespace
                s["span"] = (0, len(line_text))
                continue
        full = "\n".join(lines)
        if s["excerpt"] and s["excerpt"] in full:
            s["status"] = "WRONG_LINE"
        elif norm_ws(s["excerpt"]) and norm_ws(s["excerpt"]) in norm_ws(full):
            s["status"] = "WRONG_LINE"
    return segments


# -- classification ----------------------------------------------------------

def split_shape(codesets_by_coder):
    """Describe the shape of a split given each coder's set of codes."""
    if len(codesets_by_coder) == 1:
        return "single-coder"
    groups = defaultdict(list)
    for coder, cs in codesets_by_coder.items():
        groups[cs].append(coder)
    sizes = sorted((len(v) for v in groups.values()), reverse=True)
    if len(sizes) == 1:
        return "unanimous"
    partition = "-".join(map(str, sizes))
    n = sum(sizes)
    if all(s == 1 for s in sizes):
        return f"{partition} ({'K-way scatter' if n >= 3 else 'split pair'})"
    if len(sizes) == 2 and sizes[-1] == 1:
        return f"{partition} (lone holdout)"
    return partition


def span_relation(segs, threshold):
    """Among differently-coded cross-coder segment pairs, how much do the
    coders' chosen excerpts overlap?"""
    scores = []
    for i in range(len(segs)):
        for j in range(i + 1, len(segs)):
            a, b = segs[i], segs[j]
            if a["coder"] == b["coder"] or a["code"] == b["code"]:
                continue
            scores.append(containment(a["span"], b["span"]))
    if not scores:
        return "n/a", None
    top = max(scores)
    rel = "overlapping" if top >= threshold else ("partial" if top > 0 else "disjoint")
    return rel, round(top, 2)


def analyze(segments, coders, threshold):
    locations = defaultdict(list)
    for s in segments:
        if s["status"].startswith("OK"):
            locations[(s["respondent_id"], s["line"])].append(s)

    ledger = []
    for key in sorted(locations, key=lambda k: (k[0], k[1] or 0)):
        rid, line = key
        segs = locations[key]
        by_coder = defaultdict(list)
        for s in segs:
            by_coder[s["coder"]].append(s)
        present = sorted(by_coder)
        codesets = {c: frozenset(x["code"] for x in by_coder[c]) for c in present}

        coverage_complete = set(present) == set(coders)
        codes_agree = len(set(codesets.values())) == 1
        if not coverage_complete:
            classification = "coverage-divergent"
        elif not codes_agree:
            classification = "code-divergent"
        else:
            classification = "convergent"

        rel, rel_score = span_relation(segs, threshold)
        per_code = {}
        for code in sorted({s["code"] for s in segs}):
            applied = sorted({s["coder"] for s in segs if s["code"] == code})
            per_code[code] = applied

        ledger.append({
            "respondent_id": rid,
            "line": line,
            "classification": classification,
            "coverage_complete": coverage_complete,
            "present": present,
            "absent": sorted(set(coders) - set(present)),
            "shape": split_shape(codesets),
            "span_relation": rel,
            "span_overlap": rel_score,
            "double_coded_by": sorted(c for c in present if len(codesets[c]) > 1),
            "confidences": sorted({s["confidence"] for s in segs if s["confidence"]}),
            "per_code": per_code,
            "segments": [{
                "coder": s["coder"], "segment_id": s["segment_id"],
                "code": s["code"], "confidence": s["confidence"],
                "excerpt": s["excerpt"], "memo": s["memo"],
            } for s in sorted(segs, key=lambda s: (s["coder"], s["code"]))],
        })
    return ledger


# -- reporting ---------------------------------------------------------------

def build_report(ledger, coders, prov, warnings, threshold):
    out = []
    w = out.append
    w("=" * 78)
    w("DIVERGENCE LEDGER  -  verify-divergences.py")
    w("=" * 78)
    for warn in warnings:
        w(f"WARNING: {warn}")
    w(f"Coders ({len(coders)}): {', '.join(coders)}")
    w(f"Excerpt-overlap threshold (containment): {threshold}")
    w("")

    ok = sum(1 for s in prov if s["status"].startswith("OK"))
    w("-- Provenance " + "-" * 64)
    w(f"{ok} of {len(prov)} coded excerpts resolved verbatim to their transcripts.")
    bad = [s for s in prov if not s["status"].startswith("OK")]
    for s in bad:
        w(f"  FAIL [{s['status']}] {s['coder']} {s['segment_id']} "
          f"{s['respondent_id']} L{s['line']}: {s['excerpt'][:70]}")
    if not bad:
        w("All excerpts verbatim and on their stated lines.")
    w("")

    w("-- Alignment overview (navigation aid, not a reliability score) " + "-" * 14)
    w(f"{'Respondent':<14}{'Convergent':>12}{'Code-div':>11}{'Coverage-div':>14}")
    by_resp = defaultdict(lambda: defaultdict(int))
    for e in ledger:
        by_resp[e["respondent_id"]][e["classification"]] += 1
    for rid in sorted(by_resp):
        r = by_resp[rid]
        w(f"{rid:<14}{r['convergent']:>12}{r['code-divergent']:>11}"
          f"{r['coverage-divergent']:>14}")
    tot = defaultdict(int)
    for e in ledger:
        tot[e["classification"]] += 1
    w(f"{'TOTAL':<14}{tot['convergent']:>12}{tot['code-divergent']:>11}"
      f"{tot['coverage-divergent']:>14}")
    w("")

    div = [e for e in ledger if e["classification"] != "convergent"]
    w(f"-- Divergence ledger ({len(div)} non-convergent locations) " + "-" * 26)
    w("Deterministic detection only. Diagnosis (D1/D2/D3, C1/C2) and resolution")
    w("are the skill's interpretive job; see SKILL.md and divergence-typology.md.")
    w("")
    for e in div:
        w(f"[{e['classification'].upper()}]  {e['respondent_id']} L{e['line']}")
        w(f"    split shape : {e['shape']}")
        w(f"    coverage    : present {e['present']}"
          + (f"  absent {e['absent']}" if e["absent"] else "  (all coders present)"))
        w(f"    span overlap: {e['span_relation']}"
          + (f" (max containment {e['span_overlap']})"
             if e["span_overlap"] is not None else ""))
        if e["double_coded_by"]:
            w(f"    double-coded: {e['double_coded_by']}")
        if e["confidences"] and len(e["confidences"]) > 1:
            w(f"    confidence  : spread {e['confidences']}")
        for code, who in e["per_code"].items():
            absent = sorted(set(e["present"]) - set(who))
            tail = f"   (not applied by: {', '.join(absent)})" if absent else ""
            w(f"      code `{code}`: {', '.join(who)}{tail}")
        for s in e["segments"]:
            conf = f", {s['confidence']}" if s["confidence"] else ""
            w(f"      - {s['coder']} [{s['segment_id']}] `{s['code']}`{conf}")
            w(f"          \"{s['excerpt']}\"")
        w("")

    conv = [e for e in ledger if e["classification"] == "convergent"]
    w(f"-- Convergent locations ({len(conv)}) " + "-" * 40)
    w("  " + ", ".join(f"{e['respondent_id']} L{e['line']}" for e in conv))
    w("=" * 78)
    return "\n".join(out)


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--codings", default="inputs/analysis",
                    help="directory of per-coder coding CSVs (default: inputs/analysis)")
    ap.add_argument("--transcripts", default="inputs/transcripts",
                    help="directory of transcripts (default: inputs/transcripts)")
    ap.add_argument("--overlap-threshold", type=float, default=0.5,
                    help="containment score at/above which two excerpts count "
                         "as the same stretch of talk (default: 0.5)")
    ap.add_argument("--json", action="store_true",
                    help="emit the ledger as JSON instead of a text report")
    args = ap.parse_args()

    for d in (args.codings, args.transcripts):
        if not os.path.isdir(d):
            sys.exit(f"error: directory not found: {d}")

    transcripts = load_transcripts(args.transcripts)
    segments, warnings = load_codings(args.codings)
    if not segments:
        sys.exit("error: no coded segments loaded; check --codings")
    coders = sorted({s["coder"] for s in segments})
    if len(coders) < 2:
        sys.exit(f"error: need at least two coders to compare; found {coders}")

    check_provenance(segments, transcripts)
    ledger = analyze(segments, coders, args.overlap_threshold)
    prov_failures = [s for s in segments if not s["status"].startswith("OK")]

    if args.json:
        print(json.dumps({
            "coders": coders,
            "overlap_threshold": args.overlap_threshold,
            "provenance": {"checked": len(segments),
                           "passed": len(segments) - len(prov_failures),
                           "failures": [{"coder": s["coder"],
                                         "segment_id": s["segment_id"],
                                         "respondent_id": s["respondent_id"],
                                         "line": s["line"], "status": s["status"]}
                                        for s in prov_failures]},
            "ledger": ledger,
        }, indent=2, ensure_ascii=False))
    else:
        print(build_report(ledger, coders, segments, warnings, args.overlap_threshold))

    sys.exit(1 if prov_failures else 0)


if __name__ == "__main__":
    main()
