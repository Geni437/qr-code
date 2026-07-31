-- Public (anon) read access to a published product's thumbnail/cover
-- images, so the public product page (Phase 3) can display them.
--
-- Buckets stay private (public = false, unchanged from 0002) -- this only
-- adds a `select` policy for the `thumbnails`/`images` buckets, scoped to
-- objects whose owning product is published and not deleted. The client
-- resolves the actual URL via `createSignedUrl`, which respects this policy
-- for the anon role same as it already does for admins.
--
-- Path convention (set by ProductImagePicker): `{productId}/{filename}`,
-- so `(storage.foldername(name))[1]` recovers the product id.

do $$
declare
  bucket text;
begin
  foreach bucket in array array['thumbnails', 'images']
  loop
    execute format(
      $sql$create policy %I on storage.objects for select
        using (
          bucket_id = %L
          and exists (
            select 1 from public.products p
            where p.id::text = (storage.foldername(name))[1]
              and p.status = 'published'
              and p.is_deleted = false
          )
        );$sql$,
      bucket || '_public_read_published', bucket
    );
  end loop;
end;
$$;
