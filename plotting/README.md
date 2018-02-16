Start with two volumes for plotting scripts and data sources.
Out of that, you need whitespace-separated list of files, which should be in 
same plot with mathcing labels and output filename suffix.
```
docker run -v $(pwd)/data:/data -v $(pwd)/scripts:/scripts <IMAGE> /scripts/startplotting /data
```
