# Setup Instructions for Supabase and Docker

Follow these steps to set up Supabase CLI and Docker for your project:

## Step 1: Install Supabase CLI

1. Install [Scoop](https://scoop.sh/) (Windows package manager) via PowerShell:
   ```bash
   iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
   ```

2. Install the Supabase CLI using Scoop:
   ```bash
   scoop install supabase
   ```

3. Verify that Supabase CLI is installed:
   ```bash
   supabase --help
   ```

## Step 2: Install Docker

1. Install Docker by following the instructions on the official website:  
   [Docker Desktop Installation for Windows](https://docs.docker.com/desktop/install/windows-install/)

2. Run Docker after installation.

### WSL2 Issues with Docker?

If you encounter issues with WSL (Windows Subsystem for Linux), follow these steps to enable the Hyper-V hypervisor:

1. Open PowerShell as an administrator and run:
   ```bash
   bcdedit /set hypervisorlaunchtype auto
   shutdown /r /t 0  # Reboot your computer to apply the changes
   ```

## Step 3: Initialize Supabase Project

1. Initialize Supabase in your project directory:
   ```bash
   supabase init
   ```

2. Log in to your Supabase account:
   ```bash
   supabase login
   ```

3. Link your project to the Supabase CLI by using your project reference ID.

   ### How to Get Your Project Reference ID:
   
   1. Go to [Supabase Dashboard](https://supabase.com/dashboard/projects).
   
   2. Select an existing project or create a new one.
   
   3. Once inside the project, copy the reference ID from the URL. It looks like this:  
      ```
      https://supabase.com/dashboard/project/eewzjaqyfwzirmqocwaf
      ```
      The string at the end (`eewzjaqyfwzirmqocwaf`) is your **Project Ref**.

4. Use the project reference ID to link the project:
   ```bash
   supabase link --project-ref {your-project-ref-id}
   ```

## Step 4: Push Your Database Schema

1. Start Docker (make sure it’s running).
   
2. Push your schema from a local SQL file:
   ```bash
   supabase db push --file path-to-your-schema.sql
   ```

# 

## Path Configuration and Routing

### Define Path Configurations

Centralize your URL paths in `src/lib/config/pathConfigs.js`:

```javascript
const url_path = {
    login: "/login",
    company_registration: "/register/company",
    company_page: "/company",
    profile_page: "/profile",
    user_register: "/register/user",
    home: "/"
}

export default url_path;
```



### Set up Routing

Use the defined paths in your `<Router>` component to make routing easier to manage:

```javascript
import url_path from 'src/lib/config/pathConfigs';
import { Router, Route } from 'some-router-library';

<Router {url}>
  <div>
    <Route path={url_path.home}><Products /></Route>
    <Route path={url_path.user_register}><Register /></Route>
    <Route path={url_path.login}><Login /></Route>
    <Route path={url_path.company_registration}><CreateCompany /></Route>
    <Route path={url_path.company_page}><CompanyRoute /></Route>
    <Route path={url_path.profile_page}><UserProfile /></Route>
  </div>
</Router>
```


# 

# Svelte + Vite

This template should help get you started developing with Svelte in Vite.

## Recommended IDE Setup

[VS Code](https://code.visualstudio.com/) + [Svelte](https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode).

## Need an official Svelte framework?

Check out [SvelteKit](https://github.com/sveltejs/kit#readme), which is also powered by Vite. Deploy anywhere with its serverless-first approach and adapt to various platforms, with out of the box support for TypeScript, SCSS, and Less, and easily-added support for mdsvex, GraphQL, PostCSS, Tailwind CSS, and more.

## Technical considerations

**Why use this over SvelteKit?**

- It brings its own routing solution which might not be preferable for some users.
- It is first and foremost a framework that just happens to use Vite under the hood, not a Vite app.

This template contains as little as possible to get started with Vite + Svelte, while taking into account the developer experience with regards to HMR and intellisense. It demonstrates capabilities on par with the other `create-vite` templates and is a good starting point for beginners dipping their toes into a Vite + Svelte project.

Should you later need the extended capabilities and extensibility provided by SvelteKit, the template has been structured similarly to SvelteKit so that it is easy to migrate.

**Why `global.d.ts` instead of `compilerOptions.types` inside `jsconfig.json` or `tsconfig.json`?**

Setting `compilerOptions.types` shuts out all other types not explicitly listed in the configuration. Using triple-slash references keeps the default TypeScript setting of accepting type information from the entire workspace, while also adding `svelte` and `vite/client` type information.

**Why include `.vscode/extensions.json`?**

Other templates indirectly recommend extensions via the README, but this file allows VS Code to prompt the user to install the recommended extension upon opening the project.

**Why enable `checkJs` in the JS template?**

It is likely that most cases of changing variable types in runtime are likely to be accidental, rather than deliberate. This provides advanced typechecking out of the box. Should you like to take advantage of the dynamically-typed nature of JavaScript, it is trivial to change the configuration.

**Why is HMR not preserving my local component state?**

HMR state preservation comes with a number of gotchas! It has been disabled by default in both `svelte-hmr` and `@sveltejs/vite-plugin-svelte` due to its often surprising behavior. You can read the details [here](https://github.com/sveltejs/svelte-hmr/tree/master/packages/svelte-hmr#preservation-of-local-state).

If you have state that's important to retain within a component, consider creating an external store which would not be replaced by HMR.

```js
// store.js
// An extremely simple external store
import { writable } from 'svelte/store'
export default writable(0)
```
