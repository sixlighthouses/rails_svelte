<script>
    import Layout from '../layouts/layout.svelte';
    import { buttonVariants } from '$lib/components/ui/button/button.svelte';
    import { GithubLogo, ArrowUpRight } from 'phosphor-svelte';
    import { Link } from '@inertiajs/svelte';
    import * as Card from "$lib/components/ui/card/index.js";
</script> 



<svelte:head>
  <title>About</title>
</svelte:head>

<Layout>
  <div class="bg-muted border-b">
    <div class="mx-auto max-w-2xl px-6 lg:max-w-7xl lg:px-8 border-l border-r border-dashed pt-40 pb-50">
      <h1 class="text-4xl tracking-tighter text-balance max-lg:font-medium max-sm:px-4 sm:text-5xl lg:text-6xl">About us</h1>
      <p class="opacity-80 mt-4">About sixlighthouses</p>

    </div>
  </div>

  

</Layout>