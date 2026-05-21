# The PhET Tradition and the New Cost of Pedagogical Software

*Draft. Workshop essay for the day-4 "physics interactives" project.*

## The insight PhET was built on

PhET Interactive Simulations was founded at the University of Colorado Boulder in 2002 by Nobel laureate Carl Wieman, around a specific educational insight: students often understand difficult abstractions better when they can manipulate a system than when they only read about it, hear a lecture about it, or solve symbolic problems after the fact. That insight had been part of the cognitive-science literature for decades, but PhET turned it into a research program. The simulations were not animations and they were not games. They were carefully engineered conceptual environments — small, manipulable worlds in which the key idea of a topic became visible, immediate, and reversible.

A good PhET simulation contains five things:

1. **A model.** A simplified version of the system under study, faithful to the concept but not to every detail of reality.
2. **A manipulable interface.** Sliders, draggable objects, toggles. The student changes things; the model responds.
3. **Immediate feedback.** Cause and effect happen on screen, in real time, with no submit button between them.
4. **Multiple linked representations.** The same phenomenon shown as physical model, graph, equation, and table, all updating together.
5. **A deliberately simplified world.** The pedagogical move is the simplification, not the realism.

These design moves are not aesthetic preferences. They are PhET's research-validated answers to specific learning problems — and they are what makes a simulation pedagogical rather than decorative.

## What it cost to build one

The historical version of this work was expensive. PhET's own development documentation gives a benchmark for a moderately complex simulation: roughly **160 hours of design, 500+ hours of software development, and 40 hours of testing**, with larger simulations requiring more.[^phet-source-code] In ordinary institutional terms, that single simulation represents months of expert labor coordinated across several specialties: a faculty member with domain authority, a learning designer who knew where students actually got confused, a programmer who could implement a dynamic model, a visual designer who could make the model legible at projector distance, and evaluators who could test whether students actually learned from the interaction. At loaded salary rates for a university research center, the all-in cost of one well-built PhET-style simulation has historically run into the tens of thousands of dollars, not counting maintenance, accessibility work, and platform migration.

That migration cost was itself substantial. Many of the original PhET simulations were authored in Java, then re-authored in Flash, then re-authored again in HTML5 as the underlying platforms decayed.[^phet-html5] The simulations faculty currently use in classrooms have already survived two complete rewrites. Each rewrite was, again, a developer-team effort, not a faculty effort.

The historical barrier, in other words, was never *coding* as a single skill. It was the *coordination of expertise*: domain knowledge, learning-science knowledge, software engineering, interface design, and longitudinal classroom evaluation, all aimed at one small interactive artifact. That coordination is what funded PhET could afford and that an individual faculty member, however motivated, could not.

## What changed

Generative AI collapses the distance between idea and prototype. A faculty member can describe a conceptual system in natural language — "show me a tank where I can vary the wavelength and amplitude of two sources and watch the interference pattern on a screen behind them" — and have a working interactive in minutes. They can iterate on the affordances ("the slider for frequency should also update the equation under the graph"), debug behavior ("the waves should reset when I click the reset button, not just stop"), tune the labels for their specific course, and generate parallel versions for different student levels.

The faculty member is still doing the hardest parts. They still know the misconception. They still know which simplification preserves the concept and which one destroys it. They still have to evaluate whether the interaction actually teaches. What they no longer have to do is wait for a funded software-development pipeline before discovering whether an interactive model is pedagogically promising.

This is a genuinely new condition. It is not "PhET, but faster." It is "PhET-as-a-genre, available to the people who used to be on the receiving end." The implication is not that polished PhET simulations become obsolete — they remain among the best examples of the form — but that faculty can now author their own conceptual environments for the topics PhET never covered, at the pace of a syllabus rather than a grant cycle.

And those uncovered topics are most of teaching. PhET concentrated on physics, chemistry, biology, math, and earth science because that is where its funding and audience were. The same design tradition — visual systems, direct manipulation, immediate feedback, linked representations, deliberate simplification — applies just as well to topics that have never had a simulation tradition:

- A rhetorical-feedback-loop simulator for a writing class.
- A small-N qualitative-coding visualizer for a methods class.
- A bargaining-game widget for an economics tutorial.
- A representation/parameter visualizer for an attention-mechanism explainer in a CS class.
- An infrastructure-decay simulator for an urban-studies seminar.
- A historical-counterfactual sandbox for an intro history course.

None of these existed at PhET scale because none of them had the funding to be built by a team. All of them are now within reach of a faculty member with Claude Code and an afternoon.

## What does not change

The risk of the new condition is that the technical floor has dropped much faster than the design floor. A bad AI-generated simulation can be very seductive: sliders, particles, graphs, color, motion, all responding immediately to the user — and no clear learning goal at the center of it. PhET's hardest lesson was not "make things interactive." It was *make the right things interactive, in the right way, and constrain everything else.* That lesson is more important now than it was when the technical barriers did the constraint work automatically.

The skill that lives alongside this essay (see [skill-draft/SKILL.md](skill-draft/SKILL.md)) is built around that constraint. Its first move is not to write code. Its first move is to make the faculty member name the learning goal, the misconception, the variables that should be manipulable, the variables that should be deliberately hidden, and the limitations of the model. Only after that work is done does it generate the HTML file.

That order matters. The cheapness of the prototype is the new affordance; the discipline of the design is what makes the affordance worth using.

[^phet-source-code]: PhET Interactive Simulations, "Source Code" documentation page. Last verified at <https://phet.colorado.edu/en/about/source-code> (link should be re-checked at time of publication; PhET's documentation occasionally moves).

[^phet-html5]: The HTML5 migration is documented in PhET's development notes and in published papers describing the move from Java/Flash to HTML5, motivated by the deprecation of those plugins in major browsers.
