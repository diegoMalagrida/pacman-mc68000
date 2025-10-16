# 🟡👾 Pac-Man en Easy68K 🏆🍒


Este es un proyecto desarrollado para la asignatura **Estructura de Computadores II**, en el cual implementamos una versión del clásico **Pac-Man** utilizando el entorno de ensamblador **Easy68K**.

## 🎥 Demo del Juego

[<video src="media/pac.mp4" controls width="600"></video>
](https://github.com/user-attachments/assets/ecb84285-bc10-492f-9e88-c98d55a8f4b3)
## 🎮 Introducción y Manual de Uso

El juego sigue la mecánica clásica de Pac-Man: moverse a través de un laberinto, comer puntos y evitar a los fantasmas. Se han añadido características únicas como **un modo de depuración y un sistema de puntuación**.

### ✅ **Controles:**
- `W` → Mover arriba
- `A` → Mover izquierda
- `S` → Mover abajo
- `D` → Mover derecha
- `P` → Modo depuración (muestra el "target" de los fantasmas)

### 🎯 **Objetivo del Juego**
- Recoge todos los puntos del laberinto sin ser atrapado por los fantasmas.
- Cada **punto** otorga **10 puntos**.
- Cada **Big Pellet** otorga **50 puntos** y activa el modo de caza.
- Si comes una Big Pellet, puedes **comer fantasmas**, obteniendo **200 puntos por cada uno**.
- Si pierdes todas tus vidas, el juego termina.

---

## 🛠️ Estructura del Código

El proyecto está dividido en múltiples archivos `.X68`, cada uno con una funcionalidad específica:

### 📌 **Gestión del Juego**
- `MAIN.X68` → Controla la ejecución principal del juego.
- `STATES.X68` → Maneja los diferentes estados del juego (menú, juego, game over).

### 👾 **Personajes y Enemigos**
- `PACMAN.X68` → Controla el movimiento y la lógica de Pac-Man.
- `BLINKY.X68`, `INKY.X68`, `PINKY.X68`, `CLYDE.X68` → Controlan el comportamiento de los fantasmas.

### 🗺️ **Mapa y Visualización**
- `MAP.X68`, `MAPDATA.X68` → Gestionan el laberinto y su renderizado.
- `GFX.X68` → Maneja los sprites y efectos visuales.

### 🔢 **Puntuación y FPS**
- `SCORE.X68` → Sistema de puntuación.
- `FPS.X68` → Control de la tasa de fotogramas por segundo (FPS).

### 🔧 **Utilidades y Configuración**
- `UTIL.X68` → Funciones generales como reiniciar niveles y mostrar texto.
- `CONST.X68`, `SYSCONST.X68`, `UTLCONST.X68` → Almacenan constantes globales.
- `SYSTEMVARS.X68`, `VARS.X68` → Manejan variables globales.

---

## 🔄 Flujo y Gestión de Estados

El juego sigue un sistema basado en estados:
1. **Introducción** → Pantalla de portada.
2. **Instrucciones** → Explicación de reglas.
3. **Juego** → Desarrollo principal.
4. **Transición** → Cambio de nivel.
5. **Game Over** → Fin de la partida.

Cada estado sigue estas fases:
- **Inicialización**: Configuración de variables.
- **Actualización**: Control del juego y cambios de estado.
- **Dibujado**: Renderizado en pantalla.

---

## 🎨 Creación y Procesamiento de Imágenes Personalizadas

Para mejorar la estética del juego, creamos **sprites personalizados** para Pac-Man y los fantasmas en **Photoshop**, asegurándonos de que tuvieran un fondo uniforme de **color rosa**. Este fondo se usó como transparencia para que no apareciera en la renderización del juego.

Dado que Easy68K no tiene soporte nativo para imágenes, tuvimos que convertirlas a un formato compatible con el ensamblador. Para ello, creamos un **proyecto en Java en NetBeans**, que:
1. **Leía los píxeles de la imagen en formato `.bmp`**.
2. **Convertía cada píxel a su código hexadecimal correspondiente**.
3. **Generaba un archivo con los datos en un formato adecuado para ensamblador**.

Luego, utilizamos la **tarea 82 del `TRAP #15`** en Easy68K para dibujar píxel a píxel los sprites dentro del juego. Aunque este método fue laborioso, permitió una representación precisa de los personajes y enemigos.

---

## 🚧 Principales Desafíos y Soluciones

### 🎮 **1. Movimiento preciso de Pac-Man**
- Se implementó **detección de colisiones avanzada** para mejorar los giros en pasillos estrechos.
- Se diseñó un sistema que **anticipa la próxima posición de Pac-Man** antes de moverlo.

### 👻 **2. Inteligencia Artificial de los Fantasmas**
- Se implementaron los **modos de comportamiento originales**:
  - `Blinky` (rojo) → Persigue directamente a Pac-Man.
  - `Pinky` (rosa) → Predice 4 casillas por delante.
  - `Clyde` (naranja) → Huye si está demasiado cerca.
  - `Inky` (azul) → Usa la posición de Blinky para calcular su ruta.
- Se programó la lógica para que **cambien entre modos Chase y Scatter**, igual que en el juego original.

---

## 🎨 Características Adicionales
✔ **Modo Debug** (`P`) para ver los objetivos de los fantasmas.  
✔ **Audio con archivos `.wav`** para efectos sonoros.  
✔ **Sistema de FPS dinámicos** para una jugabilidad estable.  
✔ **Sistema de High Score guardado en archivos**.  
✔ **Sprites personalizados procesados con un conversor en Java**.  

---

## 📌 Conclusión

Este proyecto nos permitió profundizar en **ensamblador** y aplicar conocimientos avanzados sobre **hardware, interrupciones y manipulación de memoria**. A pesar de los desafíos, logramos implementar una versión jugable de Pac-Man con varias mejoras y optimizaciones.

---

## 📜 Autores
- **[Diego Malagrida](https://github.com/diegoMalagrida)**
- **[Andreu Massanet Felix](https://github.com/Azdrii)**






