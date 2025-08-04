# --- PASO 1: Descargar y Descomprimir el Archivo ---

# URL del archivo zip
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "household_power_consumption.zip"
dataFile <- "household_power_consumption.txt"

# Descargar el archivo zip si aún no ha sido descargado
if (!file.exists(zipFile)) {
  download.file(fileUrl, zipFile, mode = "wb")
}

# Descomprimir el archivo zip si el archivo de datos no existe
if (!file.exists(dataFile)) {
  unzip(zipFile)
}


# --- PASO 2: Leer los Datos ---

# Leer los datos del archivo de texto en un data frame
# Se especifican los argumentos para manejar correctamente el formato del archivo:
# - header = TRUE: La primera fila contiene los nombres de las columnas.
# - sep = ";": Las columnas están separadas por punto y coma.
# - na.strings = "?": Los valores faltantes están representados por un "?".
# - stringsAsFactors = FALSE: Es una buena práctica leer las cadenas de texto como caracteres.
power_data <- read.table(dataFile,
                         header = TRUE,
                         sep = ";",
                         na.strings = "?",
                         stringsAsFactors = FALSE)

# Opcional: Imprimir las primeras filas para verificar que los datos se cargaron correctamente
# head(power_data)

# --- PASO 3: Convertir las Columnas de Fecha y Hora ---

power_data$DateTime <- NULL

# Convertir la columna Date original a la clase Date usando as.Date()
power_data$Date <- as.Date(power_data$Date, format = "%d/%m/%Y")

# Convertir la columna Time original a un formato de tiempo usando strptime()
power_data$Time <- strptime(power_data$Time, format = "%H:%M:%S")

class(power_data$Date)
class(power_data$Time)

# Imprimir las primeras filas para verificar que los datos se cargaron correctamente
# y que las nuevas columnas tienen el formato correcto.
# head(power_data)
# str(power_data)

# --- PASO 4: Filtrar los Datos para las Fechas Requeridas ---

# Se crea un subconjunto del data frame que contiene solo los datos
# para las fechas 2007-02-01 y 2007-02-02.
filtered_data <- subset(power_data, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))


# --- PASO 5: Generar el Gráfico y Guardarlo como PNG ---

# Se convierte la columna Global_active_power a numérica para poder graficarla.
filtered_data$Global_active_power <- as.numeric(filtered_data$Global_active_power)

# Se abre el dispositivo gráfico PNG con las dimensiones especificadas.
png("plot1.png", width = 480, height = 480)

# Se crea el histograma con los parámetros solicitados.
hist(filtered_data$Global_active_power,
     col = "purple",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

# Se cierra el dispositivo gráfico, lo que guarda el archivo PNG en tu directorio de trabajo.
dev.off()

