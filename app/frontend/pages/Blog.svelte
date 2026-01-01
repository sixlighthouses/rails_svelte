<script>
  import Layout from '../layouts/layout.svelte';
  import * as Card from "$lib/components/ui/card/index.js";
  import { Calendar, Clock, User } from 'phosphor-svelte';
  import { Link } from '@inertiajs/svelte';

  export let blogPosts = [];
</script>

<svelte:head>
  <title>Blog</title>
</svelte:head>

<Layout>
  <div class="bg-muted border-b">
    <div class="mx-auto max-w-2xl px-6 lg:max-w-7xl lg:px-8 border-l border-r border-dashed pt-20 pb-12">
      <h1 class="text-4xl tracking-tighter text-balance max-lg:font-medium max-sm:px-4 sm:text-5xl lg:text-6xl">Blog</h1>
      <p class="opacity-80 mt-4">Latest articles, tutorials, and insights on web development.</p>
    </div>
  </div>

  <div class="mx-auto max-w-2xl px-6 lg:max-w-7xl lg:px-8 py-12 border-l border-r border-dashed">
    {#if blogPosts.length === 0}
      <div class="text-center py-12">
        <p class="text-muted-foreground text-lg">No blog posts yet.</p>
      </div>
    {:else}
      <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {#each blogPosts as post}
          <Link href={`/blog/${post.id}`} class="group">
            <Card.Root class="flex flex-col h-full hover:shadow-md transition-shadow cursor-pointer">
              <Card.Content class="flex-1">
                {#if post.image_url}
                  <div class="mb-4">
                    <img 
                      src={post.image_url} 
                      alt={post.title}
                      class="w-full h-48 object-cover rounded-md"
                    />
                  </div>
                {/if}
                <div class="flex items-center gap-2 text-sm text-muted-foreground mb-2">
                  <span class="bg-primary/10 text-primary px-2 py-1 rounded text-xs font-medium">
                    Article
                  </span>
                </div>
                <Card.Title class="text-lg line-clamp-2 group-hover:text-primary transition-colors">{post.title}</Card.Title>
                {#if post.excerpt}
                  <Card.Description class="mt-2 line-clamp-3 text-sm">{post.excerpt}</Card.Description>
                {:else if post.content}
                  <Card.Description class="mt-2 line-clamp-3 text-sm">{post.content.substring(0, 150)}...</Card.Description>
                {/if}
                <div class="flex items-center gap-4 mt-3 text-sm text-muted-foreground">
                  <div class="flex items-center gap-1">
                    <User size={14} />
                    <span class="text-xs">{post.author}</span>
                  </div>
                  <div class="flex items-center gap-1">
                    <Calendar size={14} />
                    <span class="text-xs">{new Date(post.published_at).toLocaleDateString()}</span>
                  </div>
                </div>
              </Card.Content>
              <Card.Content class="pt-4">
                <div class="flex items-center justify-between text-sm text-muted-foreground">
                  <div class="flex items-center gap-1">
                    <Clock size={14} />
                    <span>{Math.ceil(post.content.length / 200)} min read</span>
                  </div>
                </div>
              </Card.Content>
            </Card.Root>
          </Link>
        {/each}
      </div>
    {/if}
  </div>
</Layout>