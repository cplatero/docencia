# Recursos Docentes — Carlos Platero Dueñas · UPM

**Prof. Carlos Platero Dueñas**  
Departamento de Ingeniería Eléctrica, Electrónica, Automática y Física Aplicada  
Escuela Técnica Superior de Ingeniería y Diseño Industrial (ETSIDI) · UPM  

🌐 **Sitio web:** [cplatero.github.io/docencia](https://cplatero.github.io/docencia/)  
📝 **Blog:** [blogs.upm.es/carlos-platero](https://blogs.upm.es/carlos-platero)

---

## 📚 Cursos disponibles

### Máster
| Curso | Titulación | Estado |
|-------|-----------|--------|
| [Procesado de Señales e Imágenes](procesado-senales-imagenes/) | Máster en Ingeniería de Producción | ✅ Disponible |
| [Visión Artificial](vision-artificial/) | Máster en Ingeniería de Producción | ✅ Disponible |

### Grado
| Curso | Titulación | Estado |
|-------|-----------|--------|
| [Regulación Automática](regulacion-automatica/) | Grado en Ingeniería Electrónica Industrial y Automática | ✅ Disponible |
| [Sistemas Informáticos Industriales](sistemas-informaticos-industriales/) | Grado en Ingeniería Electrónica Industrial y Automática | ✅ Disponible |
| Automática | Grado en Ingeniería Electrónica Industrial y Automática | ✅ Disponible |

---

## 📖 Descripción de los cursos

### Procesado de Señales e Imágenes
Bases ortogonales, wavelets, optimización numérica, problema inverso variacional y disperso, contornos activos, registro de imágenes médicas y segmentación por cortes en grafos. 6 lecciones + 6 prácticas MATLAB.

### Visión Artificial
Formación de imágenes, modelos de cámara, procesamiento digital, preprocesado, segmentación (Otsu, Hough), morfología matemática e interpretación automática. Calibración métrica de cámaras. 7 capítulos + 6 prácticas MATLAB.

### Regulación Automática
Modelado matemático, análisis temporal y frecuencial, estabilidad (Routh, Nyquist), régimen permanente, Lugar de las Raíces y diseño de reguladores PID. Prácticas con **Arduino + MATLAB/Simulink** realizables sin instrumentación física. Colecciones de vídeos de teoría y prácticas. 14 capítulos + 4 prácticas.

### Sistemas Informáticos Industriales
Ingeniería del software orientada a objetos con UML y Proceso Unificado. 17 patrones de diseño GoF (creacionales, estructurales y de comportamiento) implementados en **C++ con CMakeLists.txt** listos para compilar. 6 capítulos + 17 ejemplos de código.

### Automática
Introducción al control de procesos (lazo abierto/cerrado, objetivos del control) y a los automatismos industriales: control todo-nada, PLC, tecnología cableada y programada, neumática. Incluye vídeo de clase y un banco de **45 exámenes resueltos** de convocatorias 2013–2026. 2 capítulos + vídeo + exámenes.

---

## 📚 Libros de texto

Todos los cursos están respaldados por libros de texto originales publicados por la Fundación General UPM (verificables en el [Registro Nacional ISBN](https://www.culturaydeporte.gob.es/webISBN/)):

| Libro | Año | ISBN |
|-------|-----|------|
| Apuntes de Regulación Automática | 2006 | 978-84-96737-05-1 |
| Apuntes de Regulación Automática II / Servosistemas | 2005 | 978-84-96244-72-6 |
| Prácticas de Regulación Automática | 2006 | 978-84-96737-04-4 |
| Apuntes de Visión Artificial | 2007 | 978-84-96737-16-7 |
| Apuntes de Informática Industrial: ADOO | 2007 | 978-84-96737-15-0 |

---

## 📄 Licencia

**Creative Commons BY-NC-SA 4.0** — Libre para uso académico con atribución.

Citar como: *Platero Dueñas, C. Recursos Docentes en Acceso Abierto. ETSIDI-UPM. github.com/cplatero/docencia*

---

## 🗂️ Estructura del repositorio

```
docencia/
├── index.html                                ← página índice de todos los cursos
├── README.md
├── procesado-senales-imagenes/               ← Procesado de Señales e Imágenes (Máster)
│   ├── index.html
│   └── material/
│       ├── teoria/cap1 … cap6/
│       └── practicas/pr1 … pr6/
├── vision-artificial/                        ← Visión Artificial (Máster + Grado)
│   ├── index.html
│   └── material/
│       ├── teoria/                           ← 7 capítulos PDF
│       └── practicas/pr1 … pr6/
├── regulacion-automatica/                    ← Regulación Automática (Grado)
│   ├── index.html
│   └── material/
│       ├── teoria/                           ← 14 capítulos PDF
│       └── practicas/                        ← 4 prácticas Arduino+MATLAB
├── sistemas-informaticos-industriales/       ← SII (Grado)
│   ├── index.html
│   └── material/
│       ├── teoria/                           ← 6 capítulos PDF
│       └── patrones/                         ← 17 ZIPs C++ con CMake
└── automatica/                               ← Automática (Grado)
    ├── index.html
    └── material/
        ├── teoria/                           ← 2 capítulos PDF
        └── examenes/                         ← 45 exámenes resueltos PDF
```
