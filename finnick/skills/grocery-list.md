# Skill: Grocery List Generator

## Purpose
Generate a weekly grocery list based on the family's meal plan, dietary restrictions, and pantry staples. Minimize Tiffany's mental load around food.

## Trigger
- Weekly: Sunday evening or Monday morning
- Manual: "make a grocery list" or "what do we need?"
- After meal planning for the week

## Inputs
1. **Meal plan** — this week's planned meals (from memory or Tiffany's input)
2. **Dietary profiles** (from USER.md):
   - Tiffany: no red meat, no gallbladder (moderate fat), lactose-sensitive, no curry/cinnamon, no sandwiches/burgers/hot dogs. Loves: seafood, Mediterranean, Asian, Mexican, Italian.
   - Craig: IBS, cooked veggies only (corn, green beans, mushrooms, light onion, simple salads). Eats all proteins including red meat.
   - Baylee: lactose-sensitive, easy eater. Backup meals: Amy's frozen, bagel bites, Eggo mini waffles.
3. **Staples list** — recurring items that should always be stocked
4. **Suvie compatibility** — flag meals that can use the Suvie for low-effort days

## Staples (always include if running low)
- Rao's pesto, spaghetti sauce, alfredo
- Taylor's salad kits
- Newman's Italian dressing
- Old Trapper peppered jerky (Craig)
- Applewood bacon (Craig)
- Fruit Loops, Raisin Bran (Baylee)
- Welch's fruit snacks (Baylee)
- Lactose-free milk
- Amy's frozen meals (pesto tortellini, cheese enchilada, bean & cheese burritos, vegetable lasagna)
- Bagel bites, Eggo mini waffles

## Process
1. Get this week's meal plan (ask Tiffany if not set)
2. Break each meal into ingredient list
3. Cross-reference dietary restrictions — flag anything that violates them
4. Deduplicate ingredients across meals
5. Add staples that are likely low
6. Organize by store section (produce, protein, dairy, pantry, frozen, other)
7. Note Suvie-compatible meals for batch prep

## Output Format
```
GROCERY LIST — Week of [date]

PRODUCE:
- [item] — for [meal]
- [item]

PROTEIN:
- [item] — for [meal]

DAIRY:
- [item]

PANTRY:
- [item]

FROZEN:
- [item]

STAPLES RESTOCK:
- [item] (if likely low)

SUVIE PREP:
- [meal] — load [day] AM, cook by [time]
```

## Constraints
- Never include red meat in Tiffany's portions (Craig can have his own)
- Watch fat content in Tiffany's meals (no gallbladder)
- Default to lactose-free dairy options
- Keep the list under 40 items — if more, flag it and ask what to cut
- Include approximate total cost if known (from previous lists)
