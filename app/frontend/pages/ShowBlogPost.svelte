<script>
  import Layout from '../layouts/layout.svelte';
  import * as Card from "$lib/components/ui/card/index.js";
  import { Calendar, Clock, User, ArrowLeft } from 'phosphor-svelte';
  import { Link } from '@inertiajs/svelte';
  import { buttonVariants } from "$lib/components/ui/button/index.js";
  import { marked } from 'marked';

  export let blogPost = {};

  const formattedDate = new Date(blogPost.published_at).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });

  const readingTime = Math.ceil(blogPost.content.length / 200);
  const htmlContent = marked(blogPost.content);
</script>

<svelte:head>
  <title>{blogPost.title}</title>
</svelte:head>

<Layout>
  <div class="bg-muted border-b">
    <div class="mx-auto max-w-2xl px-6 lg:max-w-7xl lg:px-8 border-l border-r border-dashed pt-20 pb-12">
      <div class="flex items-center gap-4 mb-4">
        <Link href="/blog" class={buttonVariants({ variant: "ghost", size: "sm" })}>
          <ArrowLeft size={20} />
          <span>Back to Blog</span>
        </Link>
      </div>
    </div>
  </div>

  <article class="mx-auto max-w-2xl px-6 lg:max-w-4xl lg:px-8 py-12 border-l border-r border-dashed">
    <Card.Root class="border-0 shadow-none">
      <Card.Header class="pb-6">
        <div class="space-y-4">
          <h1 class="text-3xl md:text-4xl font-bold tracking-tight">{blogPost.title}</h1>
          
          <div class="flex items-center gap-6 text-sm text-muted-foreground">
            <div class="flex items-center gap-2">
              <User size={16} />
              <span>{blogPost.author}</span>
            </div>
            <div class="flex items-center gap-2">
              <Calendar size={16} />
              <time datetime={blogPost.published_at}>{formattedDate}</time>
            </div>
            <div class="flex items-center gap-2">
              <Clock size={16} />
              <span>{readingTime} min read</span>
            </div>
          </div>
        </div>
      </Card.Header>
      
      <Card.Content class="pt-0">
        {#if blogPost.image_url}
          <div class="mb-8">
            <img 
              src={blogPost.image_url} 
              alt={blogPost.title}
              class="w-full rounded-lg shadow-md"
            />
          </div>
        {/if}
        
        {#if blogPost.excerpt}
          <div class="text-lg text-muted-foreground border-l-4 border-primary pl-4 italic mb-8">
            {blogPost.excerpt}
          </div>
        {/if}
        
        <div class="prose prose-gray max-w-none">
          {@html htmlContent}
        </div>
      </Card.Content>
    </Card.Root>
  </article>
</Layout>

<style>
  :global(.prose) {
    color: rgb(17 24 39 / var(--tw-text-opacity));
    max-width: none;
  }
  
  :global(.prose h2) {
    font-size: 1.5rem;
    font-weight: 700;
    margin-top: 2rem;
    margin-bottom: 1rem;
    line-height: 1.25;
  }
  
  :global(.prose p) {
    margin-top: 1.25rem;
    margin-bottom: 1.25rem;
    line-height: 1.75;
  }
  
  :global(.prose h3) {
    font-size: 1.25rem;
    font-weight: 600;
    margin-top: 1.75rem;
    margin-bottom: 0.75rem;
    line-height: 1.5;
  }
  
  :global(.prose ul) {
    list-style-type: disc;
    margin-top: 1.25rem;
    margin-bottom: 1.25rem;
    padding-left: 1.625rem;
  }
  
  :global(.prose li) {
    margin-top: 0.5rem;
    margin-bottom: 0.5rem;
  }
  
  :global(.prose blockquote) {
    font-weight: 500;
    font-style: italic;
    color: rgb(107 114 128 / 1);
    border-left-width: 0.25rem;
    border-left-color: rgb(229 231 235 / 1);
    quotes: '"\\"'"'"' "\\"';
    margin-top: 1.6em;
    margin-bottom: 1.6em;
    padding-left: 1em;
  }
  
  :global(.prose code) {
    color: rgb(244 63 94 / 1);
    font-weight: 600;
    font-size: 0.875em;
    background-color: rgb(243 244 246 / 1);
    border-radius: 0.25rem;
    padding-top: 0.125rem;
    padding-right: 0.25rem;
    padding-bottom: 0.125rem;
    padding-left: 0.25rem;
  }
  
  :global(.prose a) {
    color: rgb(59 130 246 / 1);
    text-decoration: underline;
    font-weight: 500;
  }
  
  :global(.prose a:hover) {
    color: rgb(37 99 235 / 1);
  }
</style>