-- Storage buckets for models/media/thumbnails/QR codes, and admin-only RLS
-- on storage.objects for all of them.
--
-- Scope cut: this does NOT grant public read access to any bucket. The
-- public 3D viewer (Phase 4) is the first actual consumer of public asset
-- access, and its retrieval mechanism (signed URLs vs. a path-based RLS
-- policy joined back to products.status) is better decided once that
-- feature exists rather than guessed at now. Until then, all bucket access
-- is admin-only, which is all Phase 2 (admin upload/manage) needs.

insert into storage.buckets (id, name, public) values
  ('models', 'models', false),
  ('images', 'images', false),
  ('videos', 'videos', false),
  ('documents', 'documents', false),
  ('audio', 'audio', false),
  ('thumbnails', 'thumbnails', false),
  ('qr_codes', 'qr_codes', false)
on conflict (id) do nothing;

do $$
declare
  bucket text;
begin
  foreach bucket in array array[
    'models', 'images', 'videos', 'documents', 'audio', 'thumbnails', 'qr_codes'
  ]
  loop
    execute format(
      $sql$create policy %I on storage.objects for all
        using (bucket_id = %L and public.is_admin())
        with check (bucket_id = %L and public.is_admin());$sql$,
      bucket || '_admin_all', bucket, bucket
    );
  end loop;
end;
$$;
