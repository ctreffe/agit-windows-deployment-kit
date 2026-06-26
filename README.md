# AGIT Deployment Kit

> **AI collaboration notice**  
> This project was conceived, designed, implemented and documented through an iterative collaboration between the repository maintainer (`ctreffe`) and ChatGPT (OpenAI).

> **Build once. Deploy consistently. Document everything.**

AGIT Deployment Kit is a modular deployment framework for Microsoft Windows featuring unattended setup, post-install configuration, validation and logging.

This repository intentionally starts small and grows in focused steps. The project language is English; a German README translation is added later as explicit supplementary documentation.

## Current scope

The deployment now creates a temporary `Setup` account and prepares the handoff to the built-in Administrator account.

The temporary account is only used for bootstrap purposes and is removed after the Administrator workflow completes.
