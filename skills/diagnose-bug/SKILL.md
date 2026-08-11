---
name: diagnose-bug
description: full diagnostic loop for complex bugs,such as unstable reproduction, unclear root cause, failed focused fix, intermittency, concurrency, performance regression, cross-service behavior, or environment-specific failure.
---

# Diagnose A Complex Bug

Use this skill only when the normal bug path is insufficient. Keep every step tied to a runnable signal for the reported symptom.

Read the relevant code, tests, human-facing domain documentation, and ADRs needed to build the feedback loop. Do not form a root-cause conclusion from code reading alone.

## 1. Build A Red Signal

Create the tightest agent-runnable pass/fail loop that exercises the real failing path. Prefer, in order: an existing or new test, HTTP/CLI harness, browser script, trace replay, focused service harness, property loop, differential test, or automated bisection.

Use `hitl-loop.template.sh` only when human action is unavoidable. Keep adapted harnesses under `.scratch/<effort>/` unless they become approved regression tests.

Run the loop and confirm that it matches the user's symptom. For intermittent failures, measure and raise the reproduction probability.

If no red-capable loop is possible, stop and request the smallest missing access, artifact, permission, or human step. Do not guess a fix.

## 2. Minimize

Remove one input, dependency, configuration, data item, or step at a time. Rerun after every removal. Keep only elements required to preserve the failure. Improve speed, determinism, and signal clarity.

## 3. Form Hypotheses

List at least two ranked, falsifiable hypotheses. Each states a predicted observation or a single-variable change that would disprove it. Technical hypotheses remain with the agent; escalate only permissions, product behavior, risk, or other user-owned decisions.

## 4. Probe

Test one hypothesis at a time. Prefer a debugger or profiler, then targeted instrumentation at boundaries that distinguish hypotheses. Label temporary probes with one unique prefix. For performance, measure with a benchmark, profile, query plan, or differential run before changing code.

## 5. Protect And Fix

When a stable contract can reproduce the defect:

1. convert the minimized case into a failing regression test;
2. observe red;
3. apply the smallest root-cause fix;
4. observe green;
5. rerun the original, unminimized signal.

If no suitable test surface exists, record the architectural limitation and preserve the strongest runnable validation.

## 6. Clean Up

Remove all temporary probes and one-off code, rerun focused and original validation, and report the confirmed root cause, evidence, changed behavior, regression protection, and residual risk. Route architectural prevention opportunities through `improve-codebase-architecture`; the parent completes normal review and `code-quality` gates.
