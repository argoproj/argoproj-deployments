# argoproj-deployments

This repository contains the infrastructure definition of the Argoproj [fficial Demo](cd.). To learn more about Argoproj, visit [argoproj.io](https://argoproj.github.io/).

## Applications

| Status                                                            | Application                                                                     | Endpoint                                                          |
| ----------------------------------------------------------------- | ------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| [![App Status][badge_argo_cd]][app_argo_cd]                       | [Argo CD](https://argoproj.github.io/cd)                                        | [cd.apps.argoproj.io](https://cd.apps.argoproj.io/)               |
| [![App Status][badge_argo_events]][app_events]                    | [Argo Events](https://argoproj.github.io/events)                                |                                                                   |
| [![App Status][badge_argo_rollouts]][app_argo_rollouts]           | [Argo Rollouts](https://argoproj.github.io/rollouts)                            |                                                                   |
| [![App Status][badge_argo_workflows]][app_argo_workflows]         | [Argo Workflows](https://argoproj.github.io/workflows/)                         | [workflows.apps.argoproj.io](https://workflows.apps.argoproj.io/) |
| [![App Status][badge_argo_image_updater]][app_argo_image_updater] | [Argo CD Image Updater](https://argocd-image-updater.readthedocs.io/en/stable/) |                                                                   |
| [![App Status][badge_cert_manager]][app_cert_manager]             | [Cert Manager](https://cert-manager.io/)                                        |                                                                   |
| [![App Status][badge_dex]][app_dex]                               | [Dex](https://dexidp.io/)                                                       |                                                                   |
| [![App Status][badge_external_dns]][app_external_dns]             | [External-DNS](https://kubernetes-sigs.github.io/external-dns)                  |                                                                   |
| [![App Status][badge_governor]][app_governor]                     | [Governor](https://github.com/keikoproj/governor)                               |                                                                   |
| [![App Status][badge_ingress_nginx]][app_ingress_nginx]           | [Ingress NGXIN](https://docs.nginx.com/nginx-ingress-controller/overview/)      |                                                                   |
| [![App Status][badge_istio_addons]][app_istio_addons]             | [Istio Addons](https://github.com/istio/istio/tree/master/samples/addons)       |                                                                   |
| [![App Status][badge_istio]][app_istio]                           | [Istio](https://istio.io/)                                                      |                                                                   |
| [![App Status][badge_istio_operator]][app_istio_operator]         | [Istio Operator](https://istio.io/latest/docs/setup/install/operator/)          |                                                                   |
| [![App Status][badge_prometheus]][app_prometheus]                 | [Prometheus](https://prometheus.io/)                                            | [grafana.apps.argoproj.io](https://grafana.apps.argoproj.io/)     |
| [![App Status][badge_sync_argoproj]][app_sync_argoproj]           | [Sync Argoproj](https://github.com/argoproj/argoproj-deployments)               |                                                                   |
| [![App Status][badge_sync_example_apps]][app_sync_example_apps]   | [Sync Example Apps](https://github.com/argoproj/argocd-example-apps)            |                                                                   |
| [![App Status][badge_workflow_example]][app_workflow_example]     | [Workfolw Examples](https://github.com/argoproj-labs/argo-workflows-catalog)    |                                                                   |

## Infrastructure

The infrastructure code is located under the [infrastructure/terraform](./infrastructure/terraform/gcp/README.md) folder.

### External Configurations

- [Argo Workflows Github Webhook](https://github.com/argoproj/argo/settings/hooks/263222342)

[app_argo_cd]: https://cd.apps.argoproj.io/applications/argo-cd
[badge_argo_cd]: https://cd.apps.argoproj.io/api/badge?revision=true&name=argo-cd
[app_events]: https://cd.apps.argoproj.io/applications/argo-events
[badge_argo_events]: https://cd.apps.argoproj.io/api/badge?revision=true&name=argo-events
[app_argo_rollouts]: https://cd.apps.argoproj.io/applications/argo-rollouts
[badge_argo_rollouts]: https://cd.apps.argoproj.io/api/badge?revision=true&name=argo-rollouts
[app_argo_workflows]: https://cd.apps.argoproj.io/applications/argo-workflows
[badge_argo_workflows]: https://cd.apps.argoproj.io/api/badge?revision=true&name=argo-workflows
[app_argo_image_updater]: https://cd.apps.argoproj.io/applications/argocd-image-updater
[badge_argo_image_updater]: https://cd.apps.argoproj.io/api/badge?revision=true&name=argocd-image-updater
[app_cert_manager]: https://cd.apps.argoproj.io/applications/cert-manager
[badge_cert_manager]: https://cd.apps.argoproj.io/api/badge?revision=true&name=cert-manager
[app_dex]: https://cd.apps.argoproj.io/applications/dex
[badge_dex]: https://cd.apps.argoproj.io/api/badge?revision=true&name=dex
[app_external_dns]: https://cd.apps.argoproj.io/applications/external-dns
[badge_external_dns]: https://cd.apps.argoproj.io/api/badge?revision=true&name=external-dns
[app_governor]: https://cd.apps.argoproj.io/applications/governor
[badge_governor]: https://cd.apps.argoproj.io/api/badge?revision=true&name=governor
[app_ingress_nginx]: https://cd.apps.argoproj.io/applications/ingress-nginx
[badge_ingress_nginx]: https://cd.apps.argoproj.io/api/badge?revision=true&name=ingress-nginx
[app_istio_addons]: https://cd.apps.argoproj.io/applications/istio-addons
[badge_istio_addons]: https://cd.apps.argoproj.io/api/badge?revision=true&name=istio-addons
[app_istio]: https://cd.apps.argoproj.io/applications/istio-controlplane
[badge_istio]: https://cd.apps.argoproj.io/api/badge?revision=true&name=istio-controlplane
[app_istio_operator]: https://cd.apps.argoproj.io/applications/istio-operator
[badge_istio_operator]: https://cd.apps.argoproj.io/api/badge?revision=true&name=istio-operator
[app_prometheus]: https://cd.apps.argoproj.io/applications/prometheus-operator
[badge_prometheus]: https://cd.apps.argoproj.io/api/badge?revision=true&name=prometheus-operator
[app_sync_argoproj]: https://cd.apps.argoproj.io/applications/sync-argoproj
[badge_sync_argoproj]: https://cd.apps.argoproj.io/api/badge?revision=true&name=sync-argoproj
[app_sync_example_apps]: https://cd.apps.argoproj.io/applications/sync-example-apps
[badge_sync_example_apps]: https://cd.apps.argoproj.io/api/badge?revision=true&name=sync-example-apps
[app_workflow_example]: https://cd.apps.argoproj.io/applications/workflow-examples
[badge_workflow_example]: https://cd.apps.argoproj.io/api/badge?revision=true&name=workflow-examples
