# supmap-devops

## Authentification

Pour déployer les conteneurs constituant le backend, il faut être authentifié par `docker login`.

* Générer un **Personal Access Token** sur GitHub :
   * Se rendre sur https://github.com/settings/tokens
   * Cliquer sur `Generate new token`
   * Cocher au minimum la permission `read:packages`
   * Copier le token
* Connecter Docker à GHCR avec le token :

````bash
echo 'YOUR_GITHUB_TOKEN' | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
````
