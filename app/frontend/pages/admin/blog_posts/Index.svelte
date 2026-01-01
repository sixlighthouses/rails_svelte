<script>
  import Layout from '../../../layouts/layout.svelte';
  import { Link, router } from '@inertiajs/svelte';
  import * as Card from "$lib/components/ui/card/index.js";
  import * as Button from "$lib/components/ui/button/index.js";
  import { buttonVariants } from "$lib/components/ui/button/index.js";
  import { Plus, Pencil, Trash, Eye, EyeClosed, Calendar, User } from 'phosphor-svelte';

  export let blogPosts = [];
  export let flash = {};

  function handleDelete(id) {
    if (confirm('Are you sure you want to delete this blog post?')) {
      router.delete(`/admin/blog_posts/${id}`);
    }
  }

  function handlePublish(id) {
    router.post(`/admin/blog_posts/${id}/publish`);
  }

  function handleUnpublish(id) {
    router.post(`/admin/blog_posts/${id}/unpublish`);
  }
</script>

<svelte:head>
  <title>Admin - Blog Posts</title>
</svelte:head>

<Layout>
  <div class="bg-muted border-b">
    <div class="mx-auto max-w-2xl px-6 lg:max-w-7xl lg:px-8 border-l border-r border-dashed pt-20 pb-12">
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-4xl tracking-tighter text-balance max-lg:font-medium max-sm:px-4 sm:text-5xl lg:text-6xl">Admin - Blog Posts</h1>
          <p class="opacity-80 mt-4">Manage your blog posts</p>
        </div>
        <Link href="/admin/blog_posts/new" class={buttonVariants({ variant: "default" })}>
          <Plus size={20} />
          <span>New Post</span>
        </Link>
      </div>
    </div>
  </div>

  {#if flash.notice}
    <div class="mx-auto max-w-2xl px-6 lg:max-w-7xl lg:px-8 py-4">
      <div class="bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded">
        {flash.notice}
      </div>
    </div>
  {/if}

  <div class="mx-auto max-w-2xl px-6 lg:max-w-7xl lg:px-8 py-12 border-l border-r border-dashed">
    {#if blogPosts.length === 0}
      <div class="text-center py-12">
        <p class="text-muted-foreground text-lg">No blog posts yet.</p>
        <Link href="/admin/blog_posts/new" class="mt-4 inline-block">
          <Button.Root>Create your first post</Button.Root>
        </Link>
      </div>
    {:else}
      <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {#each blogPosts as post}
          <Card.Root class="flex flex-col h-full">
            <Card.Header class="flex-1">
              <div class="flex items-center gap-2 text-sm text-muted-foreground mb-2">
                <span class="bg-primary/10 text-primary px-2 py-1 rounded text-xs font-medium">
                  {post.published ? 'Published' : 'Draft'}
                </span>
                {#if post.published_at}
                  <div class="flex items-center gap-1">
                    <Calendar size={14} />
                    <span class="text-xs">{new Date(post.published_at).toLocaleDateString()}</span>
                  </div>
                {/if}
              </div>
              <Card.Title class="text-lg line-clamp-2">{post.title}</Card.Title>
              {#if post.excerpt}
                <Card.Description class="mt-2 line-clamp-3 text-sm">{post.excerpt}</Card.Description>
              {/if}
              <div class="flex items-center gap-4 mt-3 text-sm text-muted-foreground">
                <div class="flex items-center gap-1">
                  <User size={14} />
                  <span class="text-xs">{post.author}</span>
                </div>
                <span class="text-xs">Created {new Date(post.created_at).toLocaleDateString()}</span>
              </div>
            </Card.Header>
            <Card.Content class="pt-4">
              <div class="flex flex-wrap gap-2">
                <Link href={`/admin/blog_posts/${post.id}/edit`} class={buttonVariants({ variant: "outline", size: "sm" })}>
                  <Pencil size={14} />
                  <span class="text-xs">Edit</span>
                </Link>
                
                {#if post.published}
                  <button onclick={() => handleUnpublish(post.id)} class={buttonVariants({ variant: "outline", size: "sm" })}>
                    <EyeClosed size={14} />
                    <span class="text-xs">Unpublish</span>
                  </button>
                {:else}
                  <button onclick={() => handlePublish(post.id)} class={buttonVariants({ variant: "outline", size: "sm" })}>
                    <Eye size={14} />
                    <span class="text-xs">Publish</span>
                  </button>
                {/if}
                
                <button onclick={() => handleDelete(post.id)} class={buttonVariants({ variant: "destructive", size: "sm" })}>
                  <Trash size={14} />
                  <span class="text-xs">Delete</span>
                </button>
              </div>
            </Card.Content>
          </Card.Root>
        {/each}
      </div>
    {/if}
  </div>
</Layout>