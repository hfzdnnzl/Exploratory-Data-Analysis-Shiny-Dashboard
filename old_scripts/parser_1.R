
# library
library(xlsx)
library(stringr)
library(dplyr)

# read data
crime_data = read.xlsx('data/statistik-jenayah-indeks-per-100000-penduduk-mengikut-negeri-dan-kes-tahun-2019.xlsx',sheetIndex = 1)

# parse states
states = crime_data[2,2:15]
states = unlist(states)
states = str_squish(states)
names(states) = NULL

# parse first table
df1 = data.frame()
for(i in 4:10){
  df = data.frame(NEGERI = states,x = unlist(crime_data[i,2:15]))
  colnames(df)[2] = crime_data[i,1]
  rownames(df) = NULL
  df[,2] = as.integer(df[,2])
  # cbind data
  if(nrow(df1)==0){df1 = df
  }else{df1 = left_join(df1,df)}
}
saveRDS(df1,'data/jenayah_kekerasan_2019.RDS')

# parse second table
df2 = data.frame()
for(i in 13:17){
  df = data.frame(NEGERI = states,x = unlist(crime_data[i,2:15]))
  colnames(df)[2] = crime_data[i,1]
  rownames(df) = NULL
  df[,2] = as.integer(df[,2])
  # cbind data
  if(nrow(df2)==0){df2 = df
  }else{df2 = left_join(df2,df)}
}
saveRDS(df2,'data/jenayah_hartabenda_2019.RDS')
