## ArgoCD Application Helm Chart

This Helm chart facilitates the dynamic generation of ArgoCD [Application](https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/) resources based on provided values.

### Template Overview:

The primary template file is `template/applications.yaml`. This template iterates over the `applications` field in the `values.yaml` file and creates an ArgoCD Application for each entry.

### Default Values:

The default settings for the applications allow you to set default value that will be applied to all applications. You can override those values for each application.

```yaml
environment: tool

default:
  namespace: tool-prod-axa-rev
  project: tool-prod-axa-rev
  targetRevision: main
  path: helm
  autoSync: true
```

### Adding Applications:

To add new applications, you should populate the `applications` field in the `values.yaml` file. Each application can override the default values if needed.

Example applications in the preprod environment:

```yaml
applications: 
  demo-fastify:
    repoURL: 'https://github.com/AXATechLab/demo-fastify'
    autoSync: false # we use github actions to sync the application after the build
    valuesFiles: # those files are hosted in the helm folder of the repo
      - values.yaml
      - values-develop.yaml
    parameters:
      app.image.tag: '$ARGOCD_APP_REVISION' # this will allow argocd to automatically update the image tag based on the latest commit
```

Example applications in the prod environment:

```yaml
applications: 
  demo-fastify:
    repoURL: 'https://github.com/AXATechLab/demo-fastify'
    autoSync: true # because we use tags, we want to automatically sync the application
    valuesFiles:
      - values.yaml
      - values-prod.yaml
    targetRevisionAndImageTag: "v0.0.13"
```

### Parameters:

For each application, you can set the following parameters:

- `repoURL`: The repository URL.
- `alias`: The alias of the application, used to properly sync the application when we deploy the same application in the same environment.
- `targetRevision`: Specific branch, tag, or commit you want to deploy.
- `path`: Path within the repo that contains the Helm chart.
- `valuesFiles`: List of Helm value files to use.
- `autoSync`: Determine whether the application should auto-sync.
- `parameters`: Key-value pairs representing Helm parameters.
- `targetRevisionAndImageTag`: A combined field for setting both the target revision and image tag.

### Usage:

1. Update the `values.yaml` file to include the desired applications and their respective configurations.
2. Use Helm to install or upgrade the chart.
3. ArgoCD will recognize and deploy the Application resources as specified.