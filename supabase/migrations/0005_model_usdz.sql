-- Optional USDZ variant per model, used for iOS Quick Look AR (iOS can't
-- AR-launch a .glb/.gltf directly). No new bucket/RLS needed -- it reuses
-- the existing `models` bucket and its Phase 2/4 policies, which aren't
-- scoped to file extension.
alter table public.models add column usdz_file_path text;
