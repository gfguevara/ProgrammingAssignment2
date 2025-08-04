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


# --- PASO 5: Generar el Gráfico 4 (Múltiples Paneles) y Guardarlo como PNG ---

# Convertir las columnas necesarias a numéricas.
filtered_data$Voltage <- as.numeric(filtered_data$Voltage)
filtered_data$Global_reactive_power <- as.numeric(filtered_data$Global_reactive_power)

# Se abre el dispositivo gráfico PNG.
png("plot4.png", width = 480, height = 480)

# Se configura el diseño para tener una cuadrícula de 2x2 gráficos.
par(mfrow = c(2, 2))

# --- Gráfico 1 (Arriba-Izquierda) ---
plot(datetime, filtered_data$Global_active_power,
     type = "l",
     xlab = "",
     ylab = "Global Active Power",
     col = "green")

# --- Gráfico 2 (Arriba-Derecha) ---
plot(datetime, filtered_data$Voltage,
     type = "l",
     xlab = "datetime",
     ylab = "Voltage",
     col = "orange")

# --- Gráfico 3 (Abajo-Izquierda) ---
plot(datetime, filtered_data$Sub_metering_1,
     type = "l",
     xlab = "",
     ylab = "Energy sub metering")
lines(datetime, filtered_data$Sub_metering_2, col = "red")
lines(datetime, filtered_data$Sub_metering_3, col = "blue")
legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1,
       bty = "n") # bty = "n" quita el borde de la leyenda

# --- Gráfico 4 (Abajo-Derecha) ---
plot(datetime, filtered_data$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power",
     col = "purple")

# Se crea un eje x personalizado.
# Se definen las posiciones de las marcas (ticks) para el inicio de cada día.
axis_ticks <- c(as.POSIXct("2007-02-01 00:00:00"), 
                as.POSIXct("2007-02-02 00:00:00"), 
                as.POSIXct("2007-02-03 00:00:00"))
# Se definen las etiquetas correspondientes en español.
axis_labels <- c("Thursday", "Friday", "saturday")
axis(1, at = axis_ticks, labels = axis_labels)


# Se cierra el dispositivo gráfico.
dev.off()
