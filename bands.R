library(plotly)

new.segment <- function(x0, x1, y0, y1, name='', color='black', opacity=0.8) {
    return(list(x0 = x0, x1 = x1, xref = 'x',
                y0 = y0, y1 = y1, yref = 'y',
                type = 'rect',
                fillcolor = color, 
                line = list(color=color), 
                opacity = opacity,
                hoveron = 'area',
                hoverinfo = name,
                layer = 'above'))
}

draw.bands <- function(df, bands=NULL, labels=FALSE) {
    
    # Ensure for apply function
    rownames(df) <- NULL
    
    # Sorted bands to include in plot
    if (is.null(bands)) {
        bands <- sort(unique(df$band))
    }
    
    bands.findy <- setNames(seq(1, length(bands)*2, by=2), bands)
    min.start <- min(df$start)    
    
    # Band segments
    shapes <- apply(df, 1, function(x) {
        y0      = as.integer(bands.findy[x[1]])
        y1      = y0 + 1
        x0      = x[2]
        x1      = x[3]
        name    = ifelse(is.na(x[4]), '', x[4])
        color   = ifelse(is.na(x[5]), 'black', x[5])
        opacity = ifelse(is.na(x[6]), 0.8, x[6])
        
        if (!is.na(y0)) {
            new.segment(x0, x1, y0, y1, name, color, opacity)
        }
    })
    
    # Band labels on y-axis
    annotations <- list(x = rep(min.start, length(bands.findy)),
                        y = as.integer(bands.findy)+0.5,
                        text = names(bands.findy),
                        xref = 'x',
                        yref = 'y',
                        borderpad = 10,
                        xanchor = 'right',
                        showarrow = FALSE)
    
    # Draw shapes
    p <- layout(plotly_empty(type='area'),
                shapes = shapes,
                annotations = annotations,
                autosize = T,
                margin = list(l=5, r=5, b=5, t=10, pad=0))
      
    # Hover info for shape names
    if (labels) {
        p <- add_trace(p,
                       x = (df$start+df$end)/2, 
                       y = as.integer(bands.findy[df$band])+0.5, 
                       type = 'scatter',
                       mode = 'markers',
                       opacity = 0,
                       text = df$name,
                       hoveron = 'points',
                       hoverinfo = 'text',
                       hoverlabel = list(bgcolor='white', font=c(color='black')),
                       showlegend = FALSE)
    }
    return(p)
}
