-- Lets a hotspot trigger a named animation on the model when clicked.
alter table public.hotspots add column animation_name text;

-- Public read access to a published model's file, and to media files
-- (video/audio/documents -- images/thumbnails were already opened in
-- 0003) referenced by hotspots. Needed now that the public viewer (Phase
-- 4) actually renders models and hotspot media.
--
-- Unlike 0003 (which checked only the owning product's status via path
-- prefix -- fine for thumbnails/cover images, which have no status of
-- their own), these policies check the actual owning row's status in
-- `models`/`media`, since both tables have real status columns to check
-- precisely, in addition to the parent product's.

create policy models_public_read_published on storage.objects for select
  using (
    bucket_id = 'models'
    and exists (
      select 1 from public.models m
      join public.products p on p.id = m.product_id
      where m.file_path = storage.objects.name
        and m.status = 'published'
        and m.is_deleted = false
        and p.status = 'published'
        and p.is_deleted = false
    )
  );

do $$
declare
  bucket text;
begin
  foreach bucket in array array['videos', 'audio', 'documents']
  loop
    execute format(
      $sql$create policy %I on storage.objects for select
        using (
          bucket_id = %L
          and exists (
            select 1 from public.media med
            join public.products p on p.id = med.product_id
            where med.file_path = storage.objects.name
              and med.status = 'published'
              and med.is_deleted = false
              and p.status = 'published'
              and p.is_deleted = false
          )
        );$sql$,
      bucket || '_public_read_published', bucket
    );
  end loop;
end;
$$;
