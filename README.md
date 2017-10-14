# R2Rmd
**Converts R to R Markdown**

## R2Rmd.sh

Converts

## R2Rmd.py

Converts a .R file into a .Rmd file

```sh
$ python R2Rmd.py [input_path] [optionnal: output_path]
```

Converts this :

```r
# II

# II.1

# Demonstrate the fact that comments that span
#multiple lines are put together
# And that spacing is liberal
# a)

# Code is handled as it should :

rm(list=ls())

RMSE = function(v1, v2){
  sqrt(mean((v1 - v2)^2))
}

# II.1.b)

#
#Titles are formatted and empty comments are removed
#
#
# That's it !
```

Into this:

````Rmd
# II

### II.1

Demonstrate the fact that comments that span multiple lines are put together

And that spacing is liberal

### a)

Code is handled as it should :

```{r}
rm(list=ls())

RMSE = function(v1, v2){
  sqrt(mean((v1 - v2)^2))
}
```

### II.1.b)

Titles are formatted and empty comments are removed

That's it !
````
