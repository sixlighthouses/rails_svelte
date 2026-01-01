<script>
  import Layout from '../../../layouts/layout.svelte';
  import { Link, router } from '@inertiajs/svelte';
  import * as Card from "$lib/components/ui/card/index.js";
  import * as Button from "$lib/components/ui/button/index.js";
  import { ArrowLeft, Eye, EyeSlash, Upload, LinkSimple } from 'phosphor-svelte';
  import { buttonVariants } from "$lib/components/ui/button/index.js";
  import { onMount } from 'svelte';
  import { marked } from 'marked';

  export let blogPost = {};
  export let errors = {};

  let showPreview = false;
  let markdownContent = '';
  let imageUrl = '';
  let useUrlInput = false;
  let isUploading = false;
  let formErrors = {};

  onMount(() => {
    markdownContent = blogPost.content || '';
    imageUrl = blogPost.image_url || '';
    updatePreview();
  });

  function updatePreview() {
    htmlContent = marked(markdownContent);
  }

  let htmlContent = '';

  function handleSubmit(event) {
    const formData = new FormData(event.target);
    formData.set('blog_post[content]', markdownContent);
    formData.set('blog_post[image_url]', imageUrl);
    
    router.put(`/admin/blog_posts/${blogPost.id}`, formData);
  }

  function togglePreview() {
    showPreview = !showPreview;
  }

  function toggleImageInput() {
    useUrlInput = !useUrlInput;
  }

  function handleImageUpload(event) {
    const file = event.target.files[0];
    if (file) {
      formErrors.image_url = ['File upload demo - use URL option instead'];
    }
  }
</script>

<svelte:head>
  <title>Admin - Edit Blog Post</title>
</svelte:head>

<Layout>
  <div class="bg-muted border-b">
    <div class="mx-auto max-w-2xl px-6 lg:max-w-7xl lg:px-8 border-l border-r border-dashed pt-20 pb-12">
      <div class="flex items-center gap-4 mb-4">
        <Link href="/admin/blog_posts" class={buttonVariants({ variant: "ghost", size: "sm" })}>
          <ArrowLeft size={20} />
          <span>Back to Posts</span>
        </Link>
      </div>
      <h1 class="text-4xl tracking-tighter text-balance max-lg:font-medium max-sm:px-4 sm:text-5xl lg:text-6xl">Edit Blog Post</h1>
      <p class="opacity-80 mt-4">Update your blog post</p>
    </div>
  </div>

  <div class="mx-auto max-w-2xl px-6 lg:max-w-7xl lg:px-8 py-12 border-l border-r border-dashed">
    <Card.Root>
      <Card.Header>
        <Card.Title>Blog Post Details</Card.Title>
        <Card.Description>Update the information for your blog post. Supports Markdown formatting.</Card.Description>
      </Card.Header>
      <form onsubmit={handleSubmit}>
        <Card.Content class="space-y-6">
          <div>
            <label for="title" class="block text-sm font-medium mb-2">Title *</label>
            <input
              type="text"
              id="title"
              name="blog_post[title]"
              value={blogPost.title || ''}
              class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-primary"
              required
            />
            {#if errors.title}
              <p class="text-destructive text-sm mt-1">{errors.title}</p>
            {/if}
          </div>

          <div>
            <label for="excerpt" class="block text-sm font-medium mb-2">Excerpt</label>
            <textarea
              id="excerpt"
              name="blog_post[excerpt]"
              rows="3"
              class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="A brief summary of your blog post..."
            >{blogPost.excerpt || ''}</textarea>
            {#if errors.excerpt}
              <p class="text-destructive text-sm mt-1">{errors.excerpt}</p>
            {/if}
          </div>

          <div>
            <div class="flex items-center justify-between mb-2">
              <label for="content" class="block text-sm font-medium">Content *</label>
              <button type="button" onclick={togglePreview} class={buttonVariants({ variant: "outline", size: "sm" })}>
                {#if showPreview}
                  <EyeSlash size={14} />
                  <span>Edit</span>
                {:else}
                  <Eye size={14} />
                  <span>Preview</span>
                {/if}
              </button>
            </div>
            
            {#if !showPreview}
              <textarea
                id="content"
                bind:value={markdownContent}
                rows="12"
                class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-primary font-mono text-sm"
                placeholder="Write your blog post in Markdown format..."
                required
                oninput={updatePreview}
              ></textarea>
            {:else}
              <div class="border border-input rounded-md p-4 min-h-[400px] prose prose-gray max-w-none">
                {@html htmlContent}
              </div>
            {/if}
            
            <input type="hidden" name="blog_post[content]" value={markdownContent} />
            
            {#if errors.content}
              <p class="text-destructive text-sm mt-1">{errors.content}</p>
            {/if}
          </div>

          <div>
            <label for="image_url" class="block text-sm font-medium mb-2">Image</label>
            <div class="space-y-3">
              <div class="flex items-center gap-3">
                <button
                  type="button"
                  onclick={toggleImageInput}
                  class={buttonVariants({ variant: "outline", size: "sm" })}
                >
                  {#if useUrlInput}
                    <Upload size={16} />
                    <span>Upload File</span>
                  {:else}
                    <LinkSimple size={16} />
                    <span>Use URL</span>
                  {/if}
                </button>
              </div>

              {#if useUrlInput}
                <div class="space-y-2">
                  <input
                    type="url"
                    id="image_url"
                    name="blog_post[image_url]"
                    bind:value={imageUrl}
                    class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-primary"
                    placeholder="https://example.com/image.jpg"
                  />
                  {#if imageUrl}
                    <div class="mt-2">
                      <img 
                        src={imageUrl} 
                        alt="Preview" 
                        class="max-h-32 rounded-md border border-input"
                      />
                    </div>
                  {/if}
                </div>
              {:else}
                <div class="space-y-2">
                  <div class="relative">
                    <input
                      type="file"
                      id="image"
                      accept="image/*"
                      onchange={handleImageUpload}
                      class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-primary text-sm"
                    />
                    <p class="text-xs text-muted-foreground">File upload demo - use URL option instead</p>
                  </div>
                </div>
              {/if}
            </div>
            {#if formErrors.image_url}
              <p class="text-destructive text-sm mt-1">{formErrors.image_url}</p>
            {/if}
          </div>

          <div>
            <label for="author" class="block text-sm font-medium mb-2">Author</label>
            <input
              type="text"
              id="author"
              name="blog_post[author]"
              value={blogPost.author || ''}
              class="w-full px-3 py-2 border border-input rounded-md focus:outline-none focus:ring-2 focus:ring-primary"
              placeholder="Author name"
            />
            {#if errors.author}
              <p class="text-destructive text-sm mt-1">{errors.author}</p>
            {/if}
          </div>
        </Card.Content>
        <Card.Footer class="flex justify-end gap-3">
          <Link href="/admin/blog_posts" class={buttonVariants({ variant: "outline" })}>
            Cancel
          </Link>
          <Button.Root type="submit">
            Update Post
          </Button.Root>
        </Card.Footer>
      </form>
    </Card.Root>
  </div>
</Layout>

<style>
  .prose h2 {
    font-size: 1.5rem;
    font-weight: 700;
    margin-top: 2rem;
    margin-bottom: 1rem;
  }
  
  .prose p {
    margin-top: 1.25rem;
    margin-bottom: 1.25rem;
  }
  
  .prose h3 {
    font-size: 1.25rem;
    font-weight: 600;
    margin-top: 1.75rem;
    margin-bottom: 0.75rem;
  }
  
  .prose ul {
    list-style-type: disc;
    margin-top: 1.25rem;
    margin-bottom: 1.25rem;
    padding-left: 1.625rem;
  }
  
  .prose li {
    margin-top: 0.5rem;
    margin-bottom: 0.5rem;
  }
  
  .prose code {
    color: rgb(244 63 94);
    font-weight: 600;
    font-size: 0.875em;
    background-color: rgb(243 244 246);
    border-radius: 0.25rem;
    padding-top: 0.125rem;
    padding-right: 0.25rem;
    padding-bottom: 0.125rem;
    padding-left: 0.25rem;
  }
  
  .prose blockquote {
    font-weight: 500;
    font-style: italic;
    color: rgb(107 114 128);
    border-left-width: 0.25rem;
    border-left-color: rgb(229 231 235);
    quotes: '"\\"'"'"' "\\"';
    margin-top: 1.6em;
    margin-bottom: 1.6em;
    padding-left: 1em;
  }
</style>