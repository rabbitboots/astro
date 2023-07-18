# Astro Changelog

## Astro v1.1.0 (2023-JUL-18)

* Upgraded the QuadSlice library from 1.2.0 to 1.3.0. This is a major rewrite that converts most functions to object methods.

* QuadSlice's readme and changelog documentation are now bundled with Astro (in `lib`).

* Removed `hollow` argument from `astro.newSlice()`, as the feature is no longer supported in QuadSlice.

* Started changelog.


### Upgrading from v1.0.0 to v1.1.0

* QuadSlice's public API has changed significantly. Refer to [QuadSlice's CHANGELOG.md, section 1.3.0](https://github.com/rabbitboots/quad_slice/blob/main/CHANGELOG.md#v130-2023-07-17) for details.

* Any calls to `astro.newSlice()` with the `hollow` argument set to true must be changed. The same behavior can be achieved by calling `slice:setTileEnabled(5, false)` on the slice def associated with the sprite.

