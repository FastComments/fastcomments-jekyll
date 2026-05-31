#!/usr/bin/env node
// Builds the Jekyll showcase example for the fastcomments-demos bundle.
// --baseurl makes Jekyll's relative_url filter prefix every link with
// /commenting-system-for-jekyll/ so the site works when served under that path
// (the Jekyll equivalent of 11ty's pathPrefix). Requires Ruby + Bundler on the
// build host.
import { execSync } from 'node:child_process';
import { rmSync, renameSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = dirname(fileURLToPath(import.meta.url));
const EXAMPLE = resolve(ROOT, 'example');
const OUT = resolve(ROOT, 'demo-dist');
const BASEURL = '/commenting-system-for-jekyll';

// Keep gems inside the checkout so the build host needs no write access to the
// system gem dir.
const env = { BUNDLE_PATH: 'vendor/bundle' };
const sh = (cmd, cwd = ROOT) => {
    console.log('$', cmd, `(${cwd})`);
    execSync(cmd, { stdio: 'inherit', cwd, env: { ...process.env, ...env } });
};

// The example Gemfile links the plugin via `path: ".."`, so this also exercises
// the gem as a real consumer would.
sh('bundle install', EXAMPLE);
sh(`bundle exec jekyll build --baseurl ${BASEURL}`, EXAMPLE);

rmSync(OUT, { recursive: true, force: true });
renameSync(resolve(EXAMPLE, '_site'), OUT);
console.log('Built fastcomments-jekyll demo at', OUT);
