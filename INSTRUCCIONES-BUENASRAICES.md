# Buenasraíces: publicación con acceso privado

Este proyecto usa Supabase para guardar pedidos y proteger el panel de administración con email y contraseña. La página de clientes no puede leer pedidos: sólo puede enviar uno. El panel sólo funciona para las cuentas autorizadas como administradoras.

## Una sola vez: crear la base de datos

1. Creá un proyecto en [Supabase](https://supabase.com/dashboard).
2. En **SQL Editor**, creá una consulta nueva, pegá todo el contenido de `buenasraices-supabase.sql` y ejecutala.
3. En **Authentication > Users**, creá la cuenta de email y contraseña de la dueña.
4. Copiá el UUID de esa usuaria. Volvé al SQL Editor y ejecutá la última instrucción comentada del archivo SQL, reemplazando el UUID.
5. En **Connect**, copiá el Project URL y la Publishable key. Copiá `config.example.js`, renombralo como `config.js` y pegá esos dos valores.

## En Visual Studio Code

1. Abrí la carpeta que contiene los archivos con **File > Open Folder**.
2. Instalá la extensión **Live Server**.
3. Hacé clic derecho sobre `tienda-organica.html` y elegí **Open with Live Server**.

No uses ni publiques una `service_role key`: da acceso completo a la base de datos. La web usa sólo la Publishable key, protegida por reglas de seguridad de Supabase.

## Publicación

Cuando ya funcione localmente, podés subir esta misma carpeta a Netlify, Vercel o GitHub Pages. Antes de publicar, en Supabase > Authentication > URL Configuration agregá la dirección final de tu tienda.
