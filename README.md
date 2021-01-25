# argoproj-deployments

This repository contains definition of Argoproj CI/CD infrastructure:

- argo-workflows - [![App Status](https://cd.apps.argoproj.io/api/badge?name=argo-workflows)](https://cd.apps.argoproj.io/applications/argo-workflows)
- argocd - includes argocd components. [![App Status](https://cd.apps.argoproj.io/api/badge?name=argo-cd)](https://cd.apps.argoproj.io/applications/argo-cd)
- cert-manager - cert-manager components. [![App Status](https://cd.apps.argoproj.io/api/badge?name=cert-manager)](https://cd.apps.argoproj.io/applications/cert-manager)
- argocd-notifications - argocd-notifications components. [![App Status](https://cd.apps.argoproj.io/api/badge?name=argocd-notifications)](https://cd.apps.argoproj.io/applications/argocd-notifications)
- argocd-image-updater - argocd-image-updater components. [![App Status](https://cd.apps.argoproj.io/api/badge?name=argocd-image-updater)](https://cd.apps.argoproj.io/applications/argocd-image-updater)
- argoproj - packages all together: includes namespaces and argocd applications definitions. [![App Status](https://cd.apps.argoproj.io/api/badge?name=argoproj)](https://cd.apps.argoproj.io/applications/argoproj)
- dex [![App Status](https://cd.apps.argoproj.io/api/badge?name=dex)](https://cd.apps.argoproj.io/applications/dex)


* [Argo Workflows Github Webhook](https://github.com/argoproj/argo/settings/hooks/263222342)
* [DEX OpenID](https://dex.apps.argoproj.io/dex/.well-known/openid-configuration)