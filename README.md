# Robinson — Constructive Mathematics in Lean 4

[![Lean 4](https://img.shields.io/badge/Lean-v4.28.0-blue)](https://leanprover.github.io/)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Constructive](https://img.shields.io/badge/Logic-Constructive-brightgreen)](CONSTRUCTIVISM.md)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen)](CURRENT-STATUS-PROJECT.md)

> **Status**: See [CURRENT-STATUS-PROJECT.md](CURRENT-STATUS-PROJECT.md) for complete details

**Una implementación estrictamente constructiva e intuicionista de matemáticas formales en Lean 4.**

Sin dependencias de Mathlib. Sin axiomas clásicos. Solo matemáticas computacionales.

---

## ⚠️ Filosofía Constructivista

Este proyecto es **estrictamente constructivo**:

- ❌ **Sin axiomas clásicos**: No LEM (Ley del Tercero Excluido), no AC (Axioma de Elección), no `Classical.choose`
- ✅ **Todas las pruebas son computacionales**: Cada teorema produce un algoritmo
- ✅ **Testigos explícitos**: Toda afirmación de existencia proporciona un testigo concreto
- ✅ **Lógica intuicionista**: `¬¬P` no implica `P`
- ✅ **Funciones computables**: Todo `def` es ejecutable (no `noncomputable`)

Ver [CONSTRUCTIVISM.md](CONSTRUCTIVISM.md) para detalles completos sobre la filosofía constructivista del proyecto.

## Descripción

Robinson es un proyecto de matemáticas formales desarrollado desde cero en Lean 4,
siguiendo estrictamente los principios del **constructivismo matemático**.

Cada definición es computable, cada prueba es constructiva, y ningún axioma clásico
es utilizado. El proyecto demuestra que las matemáticas pueden desarrollarse de
manera rigurosa y formal sin recurrir a la lógica clásica.

### Principios Fundamentales

1. **Constructivismo**: Solo se aceptan pruebas que construyen explícitamente los objetos matemáticos
2. **Computabilidad**: Toda función debe ser implementable como un algoritmo
3. **Intuicionismo**: La lógica subyacente es intuicionista (sin LEM)
4. **Independencia**: Sin dependencias externas (ni Mathlib ni otras bibliotecas clásicas)

## Módulos

| Módulo | Namespace | Dependencias | Estado | Constructivo |
|--------|-----------|--------------|--------|--------------|
| `Prelim.lean` | top-level | — | ✅ Completo | ✅ Sí |

**Leyenda de estado**:
- ✅ Completo — Totalmente documentado y proyectado en REFERENCE.md
- 🧊 Congelado — Inmutable, solo extensiones vía `*Ext.lean`
- 🔶 Parcial — Documentado parcialmente
- 🔄 En progreso — Desarrollo activo
- ❌ Pendiente — No iniciado

**Constructivo**: Todos los módulos deben ser ✅ (estrictamente constructivos).

## Estructura del Proyecto

```text
Robinson/
├── Prelim.lean              # Definiciones fundamentales (ExistsUnique constructivo)
├── _template.lean           # Plantilla para nuevos módulos (no importado)
└── (futuros subdirectorios temáticos)
Robinson.lean                # Módulo raíz (auto-generado por gen-root.bash)
```

**Características del código**:
- ✅ Todo `def` es computable (no `noncomputable`)
- ✅ Todo `∃` proporciona testigo explícito
- ✅ Sin `import Init.Classical` ni `open Classical`
- ✅ Sin `by_contra` para afirmaciones positivas
- ✅ Instancias `Decidable` explícitas cuando sea necesario

> A medida que el proyecto crezca, los módulos se organizarán en subdirectorios temáticos.
> Ver AI-GUIDE.md §22 para el protocolo de organización de directorios.

## Instalación

```bash
git clone https://github.com/julian1c2a/Robinson.git
cd Robinson
lake build
```

## Requisitos

- **Lean 4**: v4.28.0 o posterior
- **Lake**: Incluido con Lean 4
- **Filosofía**: Compromiso con el constructivismo matemático 😊

**Nota**: Este proyecto NO requiere Mathlib ni ninguna otra dependencia externa.

## Flujo de Trabajo de Desarrollo

```bash
# Inicializar sistema de bloqueo (solo primera vez)
bash git-lock.bash init

# Crear un nuevo módulo (soporta subdirectorios)
bash new-module.bash NombreModulo
bash new-module.bash Tema/SubModulo

# Compilar
make build

# Verificar sorry (pruebas incompletas)
make sorry

# Mostrar archivos bloqueados y estado de sorry
make status

# Regenerar archivo raíz de imports
bash gen-root.bash
```

> Ver [WORKFLOW.md](WORKFLOW.md) para el flujo de trabajo completo de desarrollo.

### ⚠️ Reglas Constructivistas Durante el Desarrollo

Antes de hacer commit de cualquier archivo `.lean`, verificar:

- [ ] No hay `import Init.Classical` ni módulos clásicos
- [ ] No hay `open Classical`
- [ ] No hay `Classical.choose`, `Classical.some`, `Classical.choice`
- [ ] No hay `by_contra` para afirmaciones positivas
- [ ] No hay `em` (tercero excluido)
- [ ] No hay `noncomputable` (excepto para predicados `Prop`)
- [ ] Todas las pruebas de existencia proporcionan testigos explícitos
- [ ] Todas las funciones son computables
- [ ] Todos los predicados decidibles tienen instancias `Decidable` explícitas

Ver [CONSTRUCTIVISM.md](CONSTRUCTIVISM.md) para la lista completa de verificación.

## Documentación

| Documento | Propósito |
|----------|---------|
| [CONSTRUCTIVISM.md](CONSTRUCTIVISM.md) | ⭐ **Filosofía constructivista del proyecto** (leer primero) |
| [AI-GUIDE.md](AI-GUIDE.md) | ⭐ **Estándares de documentación y guía para asistentes IA** |
| [REFERENCE.md](REFERENCE.md) | Referencia técnica de todas las definiciones y teoremas |
| [WORKFLOW.md](WORKFLOW.md) | Flujo de trabajo completo de desarrollo |
| [NAMING-CONVENTIONS.md](NAMING-CONVENTIONS.md) | Diccionario completo de nomenclatura estilo Mathlib |
| [CHANGELOG.md](CHANGELOG.md) | Historial de cambios |
| [DEPENDENCIES.md](DEPENDENCIES.md) | Diagramas de dependencias entre módulos |
| [DECISIONS.md](DECISIONS.md) | Registros de Decisiones Arquitectónicas (ADR) |
| [CURRENT-STATUS-PROJECT.md](CURRENT-STATUS-PROJECT.md) | Estado actual del proyecto y métricas |
| [NEXT-STEPS.md](NEXT-STEPS.md) | Fases de desarrollo planificadas |
| [THOUGHTS.md](THOUGHTS.md) | Diario de diseño e ideas |

### Documentos Clave para Nuevos Colaboradores

1. **[CONSTRUCTIVISM.md](CONSTRUCTIVISM.md)** — Entender la filosofía del proyecto
2. **[AI-GUIDE.md](AI-GUIDE.md)** — Estándares y restricciones constructivistas
3. **[REFERENCE.md](REFERENCE.md)** — API actual del proyecto
4. **[WORKFLOW.md](WORKFLOW.md)** — Cómo contribuir

## Convenciones de Nomenclatura

Este proyecto sigue las [convenciones de nomenclatura de Mathlib4](https://leanprover-community.github.io/contribute/naming.html).
Ver [NAMING-CONVENTIONS.md](NAMING-CONVENTIONS.md) para la referencia completa.

**Resumen rápido:**

| Entidad | Convención | Ejemplo |
|--------|------------|---------|
| Módulo | `UpperCamelCase` | `CoreAxioms.lean` |
| Namespace | `UpperCamelCase` | `Robinson.Topic` |
| Tipo / predicado Prop | `UpperCamelCase` | `IsSet`, `IsFun` |
| Función / def de valor | `lowerCamelCase` | `powerset`, `dom` |
| Axioma | `TAG_ShortName` | `ZF_Ext`, `MK_Pair` |
| Teorema | `subject_predicate` | `mem_pair_iff` |

**Nota constructivista**: Los nombres de teoremas deben reflejar su naturaleza constructiva.
Por ejemplo, `exists_witness` en lugar de `exists_classical`.

## Licencia

Este proyecto está bajo la Licencia MIT. Ver [LICENSE](LICENSE) para detalles.

## Autor

**Julián Calderón Almendros**

- GitHub: [@julian1c2a](https://github.com/julian1c2a)

## Créditos

### Recursos Educativos

- **Intuitionistic Type Theory** — Per Martin-Löf
- **Constructive Analysis** — Errett Bishop
- **Homotopy Type Theory** — Fundamentos constructivos
- [agregar más recursos aquí]

### Referencias Bibliográficas

- [agregar referencias aquí]

### Herramientas de IA

- **Claude Sonnet 4.6** (Anthropic) — Asistente de desarrollo

### Filosofía

Este proyecto está inspirado en la tradición constructivista de:
- **L.E.J. Brouwer** — Fundador del intuicionismo
- **Arend Heyting** — Formalización de la lógica intuicionista
- **Per Martin-Löf** — Teoría de tipos intuicionista
- **Errett Bishop** — Análisis constructivo

---

## Por Qué Constructivismo

Las matemáticas constructivas ofrecen:

1. **Claridad computacional**: Cada prueba es un algoritmo
2. **Testigos explícitos**: No hay existencia "mágica"
3. **Teoremas más fuertes**: Las pruebas constructivas son más informativas
4. **Extracción de programas**: Las pruebas se pueden ejecutar
5. **Claridad filosófica**: Las matemáticas son sobre construcciones, no existencia abstracta

Ver [CONSTRUCTIVISM.md](CONSTRUCTIVISM.md) para una discusión completa.

---

**Autor**: Julián Calderón Almendros  
**Última actualización**: 2026-04-26 00:00  
**Filosofía**: Constructivismo matemático estricto
