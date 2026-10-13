# Development Container specification

This file summarizes when to use the full spec, its canonical location, and key concepts. For authoritative definitions, use the canonical sources linked below.

## When to use the full spec

Use the **full specification** when you need:

- The authoritative definition of the Development Container Specification (behavior, processing rules, and intent).
- **Merge logic**: how metadata from image labels and `devcontainer.json` are combined when a container is created (see [containers.dev – merge logic](https://containers.dev/implementors/spec/#merge-logic)).
- Details beyond the property-by-property **Dev Container metadata reference** (e.g. lifecycle ordering, parallel execution of lifecycle scripts).
- Contributing to the spec or understanding the repo layout (spec content, proposals, contributing).

For property-by-property syntax and types, use the [Dev Container metadata reference](https://containers.dev/implementors/json_reference/) (JSON reference) instead.

## Canonical URL and spec repo

- **Specification (canonical):** [https://containers.dev/implementors/spec/](https://containers.dev/implementors/spec/)
- **Spec repository:** [github.com/devcontainers/spec](https://github.com/devcontainers/spec)

The spec repo README states that the specification content lives in the [docs/specs](https://github.com/devcontainers/spec/tree/main/docs/specs) folder; the website [containers.dev](https://containers.dev/) is the primary place to read the spec.

## Key concepts (from official docs)

The following concepts are named and described in the canonical spec and reference docs. Details are in the linked pages.

### Lifecycle scripts

When creating or using a dev container, commands can run at different points in the container’s lifecycle. The [Dev Container metadata reference – Lifecycle scripts](https://containers.dev/implementors/json_reference/#lifecycle-scripts) lists the command properties and their order.

- **Creation order (first-time setup):** `onCreateCommand` → `updateContentCommand` → `postCreateCommand`. These run **inside** the container after it has started for the first time.
- **Host command:** `initializeCommand` runs on the **host** during initialization (including during container creation and on subsequent starts).
- **After start/attach:** `postStartCommand` runs each time the container is successfully started; `postAttachCommand` runs each time a tool successfully attaches.
- **Order and failure:** Scripts run in the order described in the reference. If one lifecycle script fails, any subsequent scripts are not executed (e.g. if `postCreateCommand` fails, `postStartCommand` and later scripts are skipped).
- **Parallel execution:** Lifecycle scripts can use an object form for [parallel execution](https://containers.dev/implementors/spec/#parallel-exec); see the spec.

### Environment variables

Source: [Dev Container metadata reference – containerEnv / remoteEnv](https://containers.dev/implementors/json_reference/).

- **`containerEnv`:** Sets the variable on the container. All processes in the container see it. The value is static. A change needs a rebuild.
- **`remoteEnv`:** Sets the variable only for the tool and its sub-processes (for example terminals and tasks). It does not apply to the full container. A change does not need a rebuild.
- **Recommendation:** Use `containerEnv` when possible. Use `remoteEnv` when the value is not static, or when you do not want to rebuild.

### Merge logic (image metadata + devcontainer.json)

Metadata can come from both `devcontainer.json` and from the container image. Properties marked with a 🏷️ in the [Dev Container metadata reference](https://containers.dev/implementors/json_reference/) can be stored in the **`devcontainer.metadata` container image label** in addition to `devcontainer.json`. That label can hold an array of JSON snippets that are **automatically merged** with `devcontainer.json` (if any) when a container is created. The exact merge behavior is defined in the spec: [containers.dev/implementors/spec/#merge-logic](https://containers.dev/implementors/spec/#merge-logic).

The [Reference Implementation – Metadata in image labels](https://containers.dev/implementors/reference/#labels) describes how this label is used and how the Dev Container CLI (and other spec-supporting tools) add and consume it.

### Image metadata (container image label)

The spec envisions the same structured metadata being embeddable in images and other formats (see [devcontainers/spec README](https://github.com/devcontainers/spec)). The `devcontainer.metadata` image label ties configuration directly to a container image so that settings are picked up when the image is used (directly, in a `FROM` in a Dockerfile, or in Docker Compose). This keeps dev container configuration and image contents in sync and allows a simplified `devcontainer.json` in repos that reference the image.

## Related pages

| Topic | URL |
|-------|-----|
| Specification | [containers.dev/implementors/spec](https://containers.dev/implementors/spec/) |
| Dev Container metadata reference (properties) | [containers.dev/implementors/json_reference](https://containers.dev/implementors/json_reference/) |
| Reference implementation (CLI, labels, merge logic) | [containers.dev/implementors/reference](https://containers.dev/implementors/reference/) |
| Spec repo (docs/specs, contributing) | [github.com/devcontainers/spec](https://github.com/devcontainers/spec) |
| Dev Container guides (prebuilds, Dockerfile/Compose, authoring, GitLab CI) | [containers.dev/guides](https://containers.dev/guides) |
