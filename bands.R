library(plotly)

# Example data
samples <- 100
chromosomes <- c(paste('chr', 1:21, sep=""))
starts <- sample(1:500000, samples, replace=T)
ends <- sapply(starts, function(x) x+sample(1:10000, 1))
names <- sample(LETTERS, samples, replace=T)
colors <- sample(c("red", "green", "blue", "purple", "orange"), samples, replace=T)

df = data.frame(band  = sample(chromosomes, 100, replace=T),
                start = starts,
                end   = ends,
                name  = names,
                color = colors,
                stringsAsFactors=FALSE)

head(df)
# ------

# Real Data
chromosomes <- c(paste("chr", 1:21, sep=""), "chrX", "chrY", "chrM")
df <- read.table('data/hg38.txt', sep="\t", header=TRUE, stringsAsFactors=FALSE)

# Randomly reduce the size 
df <- df[sample(1:nrow(df), 500, replace=FALSE),]
df$color = "red"
df[sample(1:nrow(df), 100, replace=FALSE), "color"] <- "gold"
colnames(df) <- c("band", "name", "start", "end", "color")
df = df[,c("band", "start", "end", "name", "color")]
rownames(df) <- NULL

head(df)
# ------

# Helpers
new.segment <- function(x0, x1, y0, y1, name='', color='black', opacity=0.8) {
    return(list(x0=x0, x1=x1, xref='x',
                y0=y0, y1=y1, yref='y',
                type='rect',
                fillcolor=color, 
                line=list(color=color), 
                opacity=opacity,
                hoveron='area',
                hoverinfo=name,
                layer='above'))
}
# ------

# Ensure
rownames(df) <- NULL

# Formulate segmants
bands <- chromosomes # sort(unique(df$band)) # Can replace bands with any ordered vector of bands
bands.findy <- setNames(seq(1, length(bands)*2, by=2), bands)
min.start <- min(df$start)

shapes <- apply(df, 1, function(x) {
    y0 = as.integer(bands.findy[x[1]])
    y1 = y0 + 1
    x0 = x[2]
    x1 = x[3]
    name = x[4]
    color = x[5]
    if (!is.na(y0)) {
        new.segment(x0, x1, y0, y1, name, color)
    }
})
# ------

# Band labeling
annotations <- list(x = rep(min.start, length(bands.findy)),
                    y = as.integer(bands.findy)+0.5,
                    text = names(bands.findy),
                    xref = 'x',
                    yref = 'y',
                    borderpad = 10,
                    xanchor = 'right',
                    showarrow = FALSE)
# ------

# Plotting
p <- layout(plotly_empty(type = 'area'),
            shapes = shapes,
            annotations = annotations,
            autosize = T,
            margin = list(l=5, r=5, b=5, t=10, pad=0)) %>%
      
     add_trace(x = (df$start+df$end)/2, 
               y = as.integer(bands.findy[df$band])+0.5, 
               type="scatter",
               mode="markers",
               opacity = 0,
               text = df$name,
               hoveron = 'points',
               hoverinfo = 'text',
               hoverlabel = list(bgcolor='white', font=c(color='black')),
               showlegend = FALSE)

p
# ------
