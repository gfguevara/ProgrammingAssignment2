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


# --- PASO 3: Convertir la Columna de Fecha ---

# Convertir la columna Date original a la clase Date usando as.Date()
# Esto permite filtrar por fecha fácilmente.
power_data$Date <- as.Date(power_data$Date, format = "%d/%m/%Y")


# --- PASO 4: Filtrar los Datos para las Fechas Requeridas ---

# Se crea un subconjunto del data frame que contiene solo los datos
# para las fechas 2007-02-01 y 2007-02-02.
filtered_data <- subset(power_data, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))



# --- PASO 5: Generar el Gráfico 2 (Gráfico de Línea) y Guardarlo como PNG ---

# Se crea una nueva columna DateTime combinando las columnas Date y Time
# para tener un eje x continuo para el gráfico de series de tiempo.
datetime <- strptime(paste(filtered_data$Date, filtered_data$Time), "%Y-%m-%d %H:%M:%S")

# Se abre el dispositivo gráfico PNG.
png("plot2.png", width = 480, height = 480)

# Se crea el gráfico de línea.
plot(datetime, filtered_data$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)",
     xaxt = "n",
     col = "purple")

# Se crea un eje x personalizado.
# Se definen las posiciones de las marcas (ticks) para el inicio de cada día.
axis_ticks <- c(as.POSIXct("2007-02-01 00:00:00"), 
                as.POSIXct("2007-02-02 00:00:00"), 
                as.POSIXct("2007-02-03 00:00:00"))
# Se definen las etiquetas correspondientes en español.
axis_labels <- c("Jueves", "Viernes", "Sábado")
axis(1, at = axis_ticks, labels = axis_labels)

# Se cierra el dispositivo gráfico.
dev.off()

