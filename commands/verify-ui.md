# Verify UI

Take a screenshot of the running app and check for visual issues.

## Instructions

1. Check if dev server is running, start if needed:
   - `npm run dev` or `bun run dev`
   - Wait for server to be ready

2. Use browser tools to navigate to localhost (check package.json for port)

3. Take a screenshot of the current page

4. Analyze the screenshot for:
   - Layout issues (overlapping elements, broken alignment)
   - Missing content or broken images
   - Console errors visible in the UI
   - Obvious styling problems

5. Report findings:
   - If issues found: describe each with location
   - If clean: confirm UI renders correctly
