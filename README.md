# unlikely

A passphrase generation microservice based on the [EFF dice wordlist](https://www.eff.org/dice), made for a class project.

## Running

In the unlikely (heh) event you want to run this for yourself, a Docker image is published on the GitHub container registry for each release.
You can run it yourself with something like the following command:

```sh
$ docker run --rm -p 4000:4000 ghcr.io/5t0n3/unlikely:latest
```

After doing so, pointing something like `curl` or even your browser at `http://localhost:4000/passphrase` will give you a 6-word passphrase.
