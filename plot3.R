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


# --- PASO 5: Generar el Gráfico 3 (Múltiples Líneas) y Guardarlo como PNG ---

# Convertir las columnas de sub-medición a numéricas.
filtered_data$Sub_metering_1 <- as.numeric(filtered_data$Sub_metering_1)
filtered_data$Sub_metering_2 <- as.numeric(filtered_data$Sub_metering_2)
filtered_data$Sub_metering_3 <- as.numeric(filtered_data$Sub_metering_3)

# Se abre el dispositivo gráfico PNG.
png("plot3.png", width = 480, height = 480)

# Se crea el gráfico inicial con la primera línea (Sub_metering_1).
plot(datetime, filtered_data$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energy sub metering")

# Se añade la segunda línea (Sub_metering_2) en color rojo.
lines(datetime, filtered_data$Sub_metering_2, col = "purple")

# Se añade la tercera línea (Sub_metering_3) en color azul.
lines(datetime, filtered_data$Sub_metering_3, col = "orange")

# Se añade una leyenda en la esquina superior derecha para identificar cada línea.
legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "purple", "orange"),
       lty = 1)

# Se cierra el dispositivo gráfico.
dev.off()
