package bitmapreader;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

public class BitmapReader {

    public static void main(String[] args) {
        // Ruta del directorio donde están los archivos BMP
        File folder = new File("SPRITES/EXPORTED");

        // Verificar si la carpeta existe
        if (!folder.exists() || !folder.isDirectory()) {
            System.out.println("La ruta proporcionada no es una carpeta válida.");
            return;
        }

        // Color de fondo (magenta brillante: 255, 0, 255)
        final int BACKGROUND_COLOR = 0xFF00FF;

        // Máximo de colores por línea
        final int COLORS_PER_LINE = 4;

        // Obtener todos los archivos en la carpeta
        File[] files = folder.listFiles((dir, name) -> name.toLowerCase().endsWith(".bmp"));

        if (files == null || files.length == 0) {
            System.out.println("No se encontraron archivos BMP en la carpeta.");
            return;
        }

        // Crear o sobrescribir el archivo EXPORTED.txt
        try (PrintWriter writer = new PrintWriter(new FileWriter("SPRITES/EXPORTED/EXPORTED.txt"))) {
            // Procesar cada archivo BMP en la carpeta
            for (File file : files) {
                try {
                    // Leer la imagen
                    BufferedImage image = ImageIO.read(file);

                    // Verificar que la imagen no sea nula
                    if (image == null) {
                        writer.println("El archivo " + file.getName() + " no es un archivo BMP válido.");
                        continue;
                    }

                    int width = image.getWidth();
                    int height = image.getHeight();

                    // Crear una lista para guardar todos los colores de la imagen
                    ArrayList<String> colors = new ArrayList<>();

                    // Recorrer los píxeles y almacenar los colores en el array
                    for (int y = 0; y < height; y++) {
                        for (int x = 0; x < width; x++) {
                            int pixel = image.getRGB(x, y);

                            // Extraer los componentes RGB
                            int red = (pixel >> 16) & 0xFF;
                            int green = (pixel >> 8) & 0xFF;
                            int blue = pixel & 0xFF;

                            // Convertir a formato $10BBGGRR si es fondo, $00BBGGRR si no
                            int rgbValue;
                            if ((red << 16 | green << 8 | blue) == BACKGROUND_COLOR) {
                                rgbValue = 0x10000000 | (blue << 16) | (green << 8) | red;
                            } else {
                                rgbValue = (blue << 16) | (green << 8) | red;
                            }

                            // Agregar el color en formato hexadecimal al array
                            colors.add(String.format("$%08X", rgbValue));
                        }
                    }

                    // Escribir los colores desde el array al archivo
                    String baseName = file.getName().substring(0, file.getName().lastIndexOf('.'));
                    writer.println(); // Línea en blanco antes del nuevo sprite
                    writer.println(baseName); // Encabezado con el nombre del sprite

                    for (int i = 0; i < colors.size(); i++) {
                        if (i > 0 && i % COLORS_PER_LINE == 0) {
                            writer.println(); // Nueva línea después de cada 7 colores
                            writer.print("                          DC.L    ");
                        } else if (i % COLORS_PER_LINE == 0) {
                            writer.print("                          DC.L    ");
                        }
                        writer.print(colors.get(i));

                        // Agregar coma solo entre colores dentro de la misma línea
                        if ((i + 1) % COLORS_PER_LINE != 0 && i < colors.size() - 1) {
                            writer.print(",");
                        }
                    }

                    writer.println(); // Nueva línea al final de los datos de la imagen

                } catch (IOException e) {
                    writer.println("Error al leer el archivo BMP: " + e.getMessage());
                }
            }

            System.out.println("Los datos se han guardado en EXPORTED.txt");

        } catch (IOException e) {
            System.out.println("Error al escribir en el archivo: " + e.getMessage());
        }
    }
}
