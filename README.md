# [organizr/docker-base](https://github.com/organizr/docker-base)

[![Layers](https://img.shields.io/microbadger/layers/organizr/base?color=e93071&style=for-the-badge)](https://microbadger.com/images/organizr/base)
[![Size](https://img.shields.io/docker/image-size/organizr/base?color=e93071&style=for-the-badge)](https://hub.docker.com/r/organizr/base/)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/organizr/docker-base/Build%20Container?color=e93071&style=for-the-badge&logo=github&logoColor=41add3)](https://github.com/organizr/docker-base/actions?query=workflow%3A%22Build+Container%22)
[![Docker Pulls](https://img.shields.io/docker/pulls/organizr/base?color=e93071&style=for-the-badge&logo=docker&logoColor=41add3)](https://hub.docker.com/r/organizr/base/)
[![Discord Chat](https://img.shields.io/discord/374648602632388610?color=e93071&logo=discord&logoColor=41add3&style=for-the-badge)](https://organizr.app/discord)
[![Lisence](https://img.shields.io/github/license/organizr/docker-base?color=e93071&style=for-the-badge)](LICENSE.md)

The baseimage for our [Organizr](https://github.com/organizr/docker-organizr) container.

Based on alpine-linux, powered by S6-overlay, inspired by [linuxserver.io](https://github.com/linuxserver/)

Weekly package updates using scheduled runs in [build.yml](.github/workflows/build.yml#L9)

## Multi-arch

Manifested docker images built with buildkit.

Supported architetures:

| Architecture | Tag |
| :----: | --- |
| x86-64 | master-amd64 |
| arm64 | master-arm64 |
| armhf | master-arm |

### Credits

* [causefx](https://github.com/causefx) - The man behind Organizr
* [Chris Yocum](https://github.com/christronyxyocum) - For creating, and maintainig the original container
* [Roxedus](https://github.com/roxedus) - For updating and redoing the CI pipeline and container
