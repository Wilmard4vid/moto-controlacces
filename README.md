# MotoControl — con login y Supabase

Esta versión ya no depende de Claude: usa **Supabase** como base de datos con
inicio de sesión, y la subes tú mismo a **GitHub Pages** (gratis).

## 1. Crear el proyecto en Supabase

1. Entra a https://supabase.com, crea una cuenta y un proyecto nuevo (elige
   una contraseña de base de datos y guárdala).
2. En el menú izquierdo ve a **SQL Editor** → **New query**.
3. Abre el archivo `supabase-schema.sql` de esta carpeta, copia todo su
   contenido, pégalo ahí y dale **Run**. Esto crea las tablas, la seguridad
   (RLS) y activa el tiempo real.

## 2. Crear las cuentas (tú y tus padres)

Por seguridad, esta app **no permite que cualquiera se registre solo**:
las cuentas las creas tú manualmente.

1. En Supabase ve a **Authentication → Users → Add user**.
2. Crea una cuenta para ti y una para cada uno de tus padres (correo +
   contraseña). Marca "Auto Confirm User" para que no tengan que confirmar
   por correo.
3. Comparte esas credenciales con ellos por un medio seguro.

Si más adelante quieres que la gente se registre por su cuenta, en
**Authentication → Providers → Email** puedes activar "Enable email
signups" — pero para una app familiar, lo manual es más simple y seguro.

## 3. Conectar la app a tu proyecto

1. En Supabase ve a **Settings → API**.
2. Copia el **Project URL** y la **anon public key**.
3. Abre `index.html` en un editor de texto y busca estas dos líneas cerca
   del inicio del `<script>`:
   ```js
   const SUPABASE_URL = "PEGA_AQUI_TU_SUPABASE_URL";
   const SUPABASE_ANON_KEY = "PEGA_AQUI_TU_SUPABASE_ANON_KEY";
   ```
4. Reemplaza los dos valores por los que copiaste y guarda el archivo.

## 4. Subir la app a GitHub Pages

1. Crea un repositorio nuevo en GitHub (puede ser público o privado; si es
   privado, GitHub Pages gratis solo funciona en cuentas de pago — si
   quieres que sea gratis y privado, considera Netlify o Vercel en su
   lugar, el proceso es muy parecido).
2. Sube `index.html` a la raíz del repositorio (arrastra el archivo desde
   la pestaña "Add file → Upload files" en GitHub, o con `git push`).
3. Ve a **Settings → Pages** del repositorio, en "Branch" elige `main` y
   la carpeta `/root`, guarda.
4. Espera uno o dos minutos y GitHub te dará un enlace tipo
   `https://tu-usuario.github.io/tu-repositorio/`.

## 5. Probarla

1. Abre el enlace de GitHub Pages.
2. Inicia sesión con una de las cuentas que creaste.
3. Agrega una moto o un movimiento de prueba y confirma que aparece si
   entras desde otra cuenta o dispositivo — eso confirma que Supabase está
   sincronizando correctamente.

## Notas

- El anon key es público por diseño (así funciona Supabase); lo que
  protege tus datos es la seguridad a nivel de fila (RLS) que ya quedó
  configurada en `supabase-schema.sql`: solo cuentas con sesión iniciada
  pueden leer o escribir.
- El plan gratis de Supabase es más que suficiente para el uso de una
  flota pequeña.
- Si algún día quieres volver a la versión dentro de Claude (sin
  necesidad de hosting propio), aún tienes ese archivo disponible.
