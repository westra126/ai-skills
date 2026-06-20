# Speaker Notes — Refactorización SOLID del TaskManager

## Slide 1: Título (generada automáticamente)

*(Sin notas de presentador)*

## Slide 2: Agenda

Hola a todos. El ejercicio de hoy parte de un componente real: el TaskManager. Vamos a aplicar principios SOLID, patrones GoF, y al final documentamos la decisión con un ADR.
Vamos a recorrer rápidamente los temas. El enfoque es práctico: detectar problemas, proponer solución y justificar con trade-offs.

## Slide 3: Escenario actual

Aquí tenemos las 7 responsabilidades del TaskManager. Es un caso típico de "God Object" — un antipatrón documentado.
¿Alguien ha trabajado con un componente así? Seguramente sí — es muy común.
Las 3 dependencias concretas son SqlTaskRepository, SmtpEmailSender y PdfReportGenerator. Y ahora nos piden agregar WhatsApp y auditoría extendida.
Veamos qué principios se violan.

## Slide 4: Violaciones SOLID — Resumen

Esta es la tabla resumen. No vamos a entrar en detalle todavía — cada principio tiene su propia slide.
Lo importante aquí es que se violan los 5 principios SOLID. Eso es una señal clara de que el componente necesita rediseño.

## Slide 5: SRP — Single Responsibility Principle

El punto clave es que cada fila de la tabla representa una razón para cambiar independiente.
Si cambian las reglas de notificación, no debería tocarse la lógica de persistencia.
Un módulo que valida usuarios, envía correos y genera reportes viola este principio.
Pero SRP no es la única violación...

## Slide 6: OCP — Open/Closed Principle

Miren el código. Agregar WhatsApp obliga a abrir y modificar TaskManager — eso viola OCP.
Lo correcto sería agregar una nueva clase que implemente una interfaz de notificación, sin tocar el código existente.
Observer y Strategy son justamente los patrones GoF que nos permiten cumplir OCP.

## Slide 7: DIP — Dependency Inversion Principle

Este es el punto más importante del ejercicio.
TaskManager es lógica de negocio — alto nivel — pero depende directamente de SqlTaskRepository, que es infraestructura de bajo nivel.
El dominio importa clases de infraestructura — esa es una señal de alerta clara.
La consecuencia es que no podemos probar el dominio sin la base de datos real, y no podemos migrar a MongoDB sin reescribir todo.

## Slide 8: ISP + LSP — Violaciones adicionales

Sobre ISP: si un consumidor solo necesita generar reportes, no debería depender de una interfaz que incluye notify(), audit(), persist(). La solución es segregar interfaces.
Sobre LSP: sin abstracciones no hay nada que sustituir — no podemos intercambiar SmtpEmailSender por WhatsappNotifier. La solución es definir contratos que toda implementación respete.
¿Cómo se ve el rediseño?

## Slide 9: Rediseño propuesto

En el diagrama vemos que TaskManager se convierte en un orquestador que depende de 4 interfaces: TaskRepository, NotificationService, AuditService y ReportGenerator.
Cada interfaz tiene múltiples implementaciones. Esto permite agregar WhatsApp — una nueva implementación de NotificationService — sin tocar TaskManager.

## Slide 10: Dependencias — Antes

*(Sin notas de presentador)*

## Slide 11: Dependencias — Después

Comparemos ambos diagramas. Antes, las flechas van de TaskManager a clases concretas — dependencia directa.
Después, las flechas van de las implementaciones concretas hacia las interfaces del dominio — inversión de dependencias.
Las dependencias apuntan hacia el dominio, nunca al revés.

## Slide 12: Patrones GoF aplicados

Observer: cuando se crea una tarea, emite un evento; los notificadores son observadores que reaccionan independientemente.
Strategy: cada canal de notificación es una estrategia intercambiable. Repository abstrae la persistencia.
Decorator: la auditoría envuelve operaciones sin modificar el componente base.
Observer no conecta objetos. Conecta eventos con consecuencias.

## Slide 13: Trade-offs

Hay que ser honestos con los costos. Sí, hay más archivos e interfaces. Sí, la complejidad estructural aumenta.
Pero la mantenibilidad, testabilidad y extensibilidad mejoran significativamente.
Toda decisión arquitectónica implica renunciar a algo. Aquí sacrificamos simplicidad inicial para ganar evolución sostenible.

## Slide 14: ADR — Architecture Decision Record

Este es el formato Nygard: Contexto, Decisión, Consecuencias. El ADR documenta la decisión para el futuro — cuando alguien pregunte "¿por qué se diseñó así?", la respuesta está aquí.
El ADR vive en el repositorio junto al código. Eso es Docs-as-Code.

## Slide 15: Gracias

Gracias por su atención. ¿Tienen alguna pregunta?
Algunas preguntas que pueden surgir: "¿Cuándo es excesivo aplicar SOLID?", "¿Cómo se maneja la inyección de dependencias?", "¿Qué pasa con el rendimiento al agregar tantas capas?"
Tiempo total estimado: unos 20 minutos más preguntas y respuestas.
