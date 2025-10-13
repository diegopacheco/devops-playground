# Helm

Helm is a package manager for Kubernetes that helps you manage Kubernetes applications. Helm uses a packaging format called charts. A chart is a collection of files that describe a related set of Kubernetes resources.

## Results

```bash
❯ ./test.sh
Casting votes...
Voting for warriors (5 votes)...
Voted for warriors
Voted for warriors
Voted for warriors
Voted for warriors
Voted for warriors
Voting for lakers (2 votes)...
Voted for lakers
Voted for lakers
Voting for bucks (3 votes)...
Voted for bucks
Voted for bucks
Voted for bucks
Voting for okc (1 vote)...
Voted for okc

Checking vote counts...
{
  "bucks": "3",
  "lakers": "2",
  "okc": "1",
  "warriors": "5"
}

Determining winner...
Winner: warriors with 5 votes!
```