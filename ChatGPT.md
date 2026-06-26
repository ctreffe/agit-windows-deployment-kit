# ChatGPT.md

# Collaboration Model v1.0

**Status:** Stable
**Applies to:** AGIT Deployment Kit
**Repository Maintainer:** ctreffe

---

# Purpose

This document describes the collaboration model that proved successful during the development of the AGIT Deployment Kit.

Its purpose is to document the engineering practices, decision-making process and collaboration principles that enabled the successful implementation of this project.

Although this document is named **ChatGPT.md**, it is intentionally written to be useful for future AI assistants as well as human contributors.

This document intentionally contains **no hidden prompts**.

Instead, it openly documents the collaboration model that emerged during the development of this repository.

---

# Core Principles

The collaboration is based on the following principles:

* Architecture before implementation.
* Discuss trade-offs before writing code.
* Prefer incremental evolution over complete redesigns.
* Documentation is part of the implementation.
* Explain architectural decisions, not only technical solutions.
* Prefer maintainability over short-term convenience.
* Favor readability over cleverness.
* Keep software modular.
* Prefer Microsoft-supported configuration methods whenever practical.
* Never hide important assumptions.
* Validate before declaring success.

---

# Repository Maintainer (ctreffe)

The repository maintainer consistently values:

* maintainability
* transparency
* modular design
* semantic versioning
* comprehensive documentation
* reproducible deployments
* structured logging
* validation on real hardware
* long-term maintainability over quick solutions

Manual intervention is considered acceptable whenever it improves safety, transparency or reliability.

This section intentionally documents engineering preferences rather than personal characteristics.

---

# Collaboration Workflow

Projects should evolve through iterative collaboration.

The preferred workflow is:

1. Understand the objective.
2. Discuss architectural alternatives.
3. Agree on the overall direction.
4. Implement incrementally.
5. Validate on real systems whenever possible.
6. Review the results together.
7. Improve the implementation.
8. Update all relevant documentation.
9. Publish only after successful validation.

---

# Decision Making

Whenever multiple technical solutions exist:

* explain the available options
* discuss advantages and disadvantages
* provide a recommendation
* justify the recommendation

The objective is informed engineering decisions rather than simply generating code.

---

# AI Responsibilities

The AI assistant is expected to contribute beyond code generation.

Its responsibilities include:

* proposing architectural improvements
* identifying opportunities to simplify solutions
* improving documentation
* suggesting better engineering practices
* questioning assumptions when appropriate
* contributing to project organization
* improving release management
* helping maintain long-term consistency across the project

The AI assistant should actively participate in improving both the software and the engineering process.

Whenever recurring patterns or successful collaboration practices emerge during a project, they should be proposed for inclusion in this Collaboration Model and, once accepted, incorporated into the AGIT project template repository.

The objective is continuous improvement of both the project and the collaboration itself.

---

# Documentation Philosophy

Documentation is considered part of the software.

Important architectural decisions should eventually be reflected in one or more of the following documents:

* README
* CHANGELOG
* PHILOSOPHY
* Release Notes
* configuration comments

Documentation should evolve together with the implementation.

---

# Repository Evolution

The repository should evolve gradually.

Large-scale rewrites should be avoided whenever incremental improvements achieve the same objective.

Backward compatibility should be preserved whenever practical.

Engineering decisions should prioritize long-term maintainability over short-term convenience.

---

# Continuous Improvement

This Collaboration Model is intentionally a living document.

After completing every project, the repository maintainer and the AI assistant should perform a short retrospective.

Whenever new collaboration patterns, engineering practices or successful workflows have been identified, this document should be updated.

Typical additions include:

* engineering practices
* collaboration patterns
* documentation standards
* release workflows
* architectural lessons learned
* testing strategies
* project organization improvements

The objective is **not** to collect personal information about the repository maintainer.

The objective is to continuously improve the shared engineering process.

---

# Template Repository

This Collaboration Model is also maintained within the AGIT Project Template Repository.

Whenever this document is improved after a completed project, the template repository should be updated accordingly.

Future projects should always begin with the latest version of the Collaboration Model.

The template repository therefore serves as the canonical starting point for all future AGIT software projects.

---

# Versioning

The Collaboration Model is versioned independently from the software project.

Version numbers should only change when meaningful improvements have been made to the collaboration process itself.

Example:

* Collaboration Model 1.0
* Collaboration Model 1.1
* Collaboration Model 2.0

Each version should represent an observable improvement in the engineering process.

---

# Transparency

This repository intentionally documents that it was conceived, designed, implemented and documented through an iterative collaboration between the repository maintainer (**ctreffe**) and **ChatGPT (OpenAI)**.

The objective is transparency.

The repository documents not only the resulting software, but also the engineering process used to create it.

---

# Definition of Success

A successful project is characterized by:

* reliable implementation
* maintainable architecture
* complete documentation
* transparent decision making
* successful validation
* reproducible releases

Software quality is measured not only by functionality, but also by how understandable, maintainable and reproducible the project remains over time.

---

# Architectural Status

This document is considered part of the software architecture.

It defines the collaboration model under which the project is designed, implemented, documented and maintained.

Changes to this document should therefore be reviewed with the same level of care as architectural changes to the software itself.
