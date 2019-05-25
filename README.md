
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bands

Simple interactive chromosome maps written in R

## Source

``` r
source("bands.R")
```

## Example Data

``` r
samples <- 250
bands <- paste('Band', 0:9)
starts <- sample(1:500000, samples, replace=TRUE)
ends <- sapply(starts, function(x) x+sample(1:10000, 1))
names <- paste('Label', sample(LETTERS, samples, replace=TRUE))
colors <- sample(c('#f3cec9', '#e7a4b6', '#cd7eaf', '#a262a9', '#6f4d96', '#3d3b72', '#182844'), samples, replace=T)
opacitys <- sample(50:100/100, samples, replace=TRUE)

df <- data.frame(band = sample(bands, samples, replace=TRUE),
                 start = starts,
                 end = ends,
                 name = names,
                 color = colors,
                 opacity = opacitys,
                 stringsAsFactors=FALSE)

dim(df)
```

    [1] 250   6

``` r
head(df)
```

``` 
    band  start    end    name   color opacity
1 Band 4 309267 310144 Label I #6f4d96    0.96
2 Band 7  24655  28810 Label D #182844    0.68
3 Band 9 359082 363749 Label Q #a262a9    0.72
4 Band 1 141285 143092 Label Y #182844    0.72
5 Band 4  24444  26772 Label I #6f4d96    0.71
6 Band 9 409560 414910 Label R #6f4d96    0.50
```

## Plot Bands

``` r
draw.bands(df)
```

![](man/figures/README-unnamed-chunk-4-1.png)<!-- -->

## Real Data Interactive Examples

Please visit <https://anfederico.github.io/bands/>
