# Analyze Contributors

Analyze git contributors in this repository and rank them by impact.

## Instructions

1. **Gather raw data** using git commands:
   - Commit counts by author: `git shortlog -sne --all`
   - Recent commits with messages: `git log --format='%an|%ad|%s' --date=short`
   - Lines changed by author: `git log --format='%an' --shortstat`
   - Active days per contributor

2. **For each contributor, investigate**:
   - What areas of the codebase do they work in? (frontend, backend, 3D, infra, etc.)
   - What features did they build or own?
   - Are their contributions complete or partial?
   - How specialized are their skills?

3. **Score each contributor on these factors** (ratings out of 5, where 5 = best):

   | Factor | Weight | Description |
   |--------|--------|-------------|
   | **Irreplaceability** | 35% | How hard would it be to find someone else with these skills? |
   | **Volume** | 20% | Raw commit count and lines changed |
   | **Feature completeness** | 20% | Did they finish what they started? |
   | **User-visible impact** | 15% | Does the end user see/experience their work? |
   | **Architecture** | 10% | Did they make real structural decisions (not just framework choices)? |

4. **Calculate weighted score** for each contributor (out of 100)

5. **Output format**:

   ## Final Contributor Rankings

   | Rank | Contributor | Commits | Score | Summary |
   |:----:|-------------|:-------:|:-----:|---------|
   | ... | ... | ... | ... | ... |

   ---

   ## Contribution Areas

   *Check mark indicates contributor made meaningful commits in that area*

   | Contributor | Frontend | Backend | 3D/Graphics | Game Logic | Infra/DevOps | Auth/Security |
   |-------------|:--------:|:-------:|:-----------:|:----------:|:------------:|:-------------:|
   | ... | ✓ | ✓ | - | ✓ | - | - |

   ---

   ## Scoring Breakdown

   *Ratings out of 5 (5 = best, 1 = worst)*

   | Factor (Weight) | Contributor1 | Contributor2 | ... |
   |-----------------|:------------:|:------------:|:---:|
   | **Irreplaceability (35%)** | X | X | ... |
   | Volume (20%) | X | X | ... |
   | Feature completeness (20%) | X | X | ... |
   | User-visible impact (15%) | X | X | ... |
   | Architecture (10%) | X | X | ... |

## Key Principles

- **Irreplaceability > Volume**: 30 commits of rare skills outweigh 100 commits of common work
- **Framework choices are NOT architecture**: Picking React vs Vue is tooling, not architecture
- **Consider "what if they left tomorrow?"**: The harder to recover, the higher they rank
- **Be fair**: Note limited involvement neutrally, don't punch down on low contributors
- **Breadth matters for irreplaceability**: Contributors spanning many areas are harder to replace
