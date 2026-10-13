---
name: devcontainers-best-practices
description: Reference for Dev Containers — devcontainer.json, the spec and schema, Features, Templates, lifecycle scripts, and differences between tools (VS Code, Cursor, Codespaces, DevPod, Zed, Podman). Use it also when a container operates differently in different tools.
license: MIT
metadata:
  author: Afonso Graça
---

# Devcontainers Best Practices

Use this skill to find the correct source for a Dev Container question. The files in `references/` summarize the official documentation. Read only the file that you need.

## Where to look

| Need | Reference file | Canonical source |
|------|----------------|------------------|
| A `devcontainer.json` property: syntax, type, behavior | [references/spec.md](references/spec.md) | [Metadata reference](https://containers.dev/implementors/json_reference/) |
| Validation and the JSON schema | [references/schema.md](references/schema.md) | [JSON schema](https://containers.dev/implementors/json_schema/) |
| Spec concepts: lifecycle, merge logic, image metadata, environment variables | [references/spec.md](references/spec.md) | [Spec](https://containers.dev/implementors/spec/) |
| Tool support, `customizations.*`, tool limitations, Podman, more than one container | [references/tools.md](references/tools.md) | [Supporting tools](https://devcontainers.github.io/supporting) |
| VS Code: workflows, prebuilds, ports, extensions, dotfiles, advanced configuration | [references/vscode-containers.md](references/vscode-containers.md) | [Developing inside a Container](https://code.visualstudio.com/docs/devcontainers/containers), [Advanced configuration](https://code.visualstudio.com/remote/advancedcontainers/overview) |
| Problems for each OS, Git credentials, performance, troubleshooting | [references/tips-and-tricks.md](references/tips-and-tricks.md) | [Tips and tricks](https://code.visualstudio.com/docs/devcontainers/tips-and-tricks) |
| Official Features, OCI references, versions, options, install order, Feature authoring | [references/features.md](references/features.md) | [Features](https://containers.dev/implementors/features/), [Authoring guide](https://containers.dev/guide/feature-authoring-best-practices) |
| Official Templates; Template vs Feature vs Dockerfile | [references/templates.md](references/templates.md) | [Templates](https://containers.dev/implementors/templates/) |

## Rules for recommendations

- Give a recommendation as a best practice only when the spec or the official documentation states it. Cite the source.
- If the official documentation does not state it, give it as a suggestion and cite the source. You can use community articles (for example [Daytona – Ultimate guide to dev containers](https://www.daytona.io/dotfiles/ultimate-guide-to-dev-containers)) with attribution. When a community article and the official documentation disagree, use the official documentation.

## Gotchas

- **Trust:** A dev container configuration or image can run any command. `initializeCommand` runs on the host. Use only configurations and images from trusted sources. See [The Red Guild – Where do you run your code](https://blog.theredguild.org/where-do-you-run-your-code/).
- **Lifecycle failure:** If one lifecycle script fails, the scripts after it do not run. The creation order is `onCreateCommand` → `updateContentCommand` → `postCreateCommand`. See [Lifecycle scripts](https://containers.dev/implementors/json_reference/#lifecycle-scripts).
- **`runArgs` has no conditions:** The tool applies `runArgs` for each container runtime. A Podman flag (for example `--userns=keep-id`) can break the configuration for Docker users. Use a shim script in `dev.containers.dockerPath`. See [references/tools.md](references/tools.md).
- **Feature versions:** If you do not give a version, the tool uses `:latest`. To pin a version, add it to the Feature ID (for example `ghcr.io/devcontainers/features/go:1`). See [Features](https://containers.dev/implementors/features/).
- **Rebuild:** A running container does not get configuration changes. Rebuild the container ("Dev Containers: Rebuild Container" or "Codespaces: Rebuild Container"). A rebuild can delete data that is not in a volume. Before you advise a rebuild, tell the user to back up `~/.claude` and each volume, and do not say that the volumes stay unless you checked them. If the repo has rebuild steps, for example `.devcontainer/REBUILD.md`, follow them.
