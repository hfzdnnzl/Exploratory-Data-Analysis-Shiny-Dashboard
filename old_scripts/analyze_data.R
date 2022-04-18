
# library
library(ggplot2)
library(dplyr)

# read data
crime_data = readRDS('data/jenayah_hartabenda_2019.RDS')
crime_data = readRDS('data/jenayah_kekerasan_2019.RDS')

# parse data
x_name = 'NEGERI'
y_name = 'JENAYAH'
x_column = crime_data %>% select(all_of(x_name))
crime_data = crime_data %>% select(-all_of(x_name))
bar_df = data.frame()
for(i in 1:nrow(crime_data)){
  for(j in 1:length(crime_data)){
    df = data.frame(x = x_column[i,1],y = colnames(crime_data)[j],z = crime_data[i,j])
    bar_df = rbind(bar_df,df)
  }
}
colnames(bar_df) = c(x_name,y_name,'JUMLAH')
saveRDS(bar_df,'data/jenayah_kekerasan_2019_reduced.RDS')

# plot data
colnames(bar_df) = c('x','y','JUMLAH')
ggplot(bar_df,aes(x=x,y=JUMLAH,fill=y,label=y)) +
  geom_bar(stat = 'identity') +
  geom_text(size=3, position = position_stack(vjust = 0.5)) + 
  ggtitle('Jenayah Hartabenda 2019') +
  xlab(x_name) + labs(fill = y_name)

ggplot(bar_df,aes(x=y,y=JUMLAH,fill=x,label=x)) +
  geom_bar(stat = 'identity') +
  geom_text(size=3, position = position_stack(vjust = 0.5)) + 
  ggtitle('Jenayah Hartabenda 2019') +
  xlab(y_name) + labs(fill = x_name)


# online example
# Year      <- c(rep(c("2006-07", "2007-08", "2008-09", "2009-10"), each = 4))
# Category  <- c(rep(c("A", "B", "C", "D"), times = 4))
# Frequency <- c(168, 259, 226, 340, 216, 431, 319, 368, 423, 645, 234, 685, 166, 467, 274, 251)
# Data      <- data.frame(Year, Category, Frequency)
