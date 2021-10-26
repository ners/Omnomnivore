Omnomnivore
===========

Delicious graph-powered recipes in only 3 microwave minutes.

# What's in the box?

[How to use this]

# Development

Development takes place on Linux. The easiest way to get started is with Nix.

We use Podman to containerise a graph DB.

# How it works

## Recipe
TBD: a recipe is a linearised subgraph with all the user choices

## Category (node)
A category is an ingredient that is not concrete, but rather presents a choice between many concrete ingredients.
For example: "bread" can be fulfilled by "white bread", "black bread", "full-corn bread", "body of Christ", ...
A category must be resolved by the user.
All ingredients under a category must share the same quantification, which is also the quantification of the category.
No, we do not support continuous eggs.

## Ingredient (node)
An ingredient is a resource that is consumed by steps, and also produced by steps.
Each ingredient has a unique name.
Each ingredient is quantifiable by its count, volume, or mass. Volume or mass can be divided and recalculated as needed. Count cannot be divided.

If multiple steps produce the same ingredient, then a choice must be given to continue resolving.

## Step (node)
A step is a transformation from input ingredients to output ingredients with respect to the given quantities of input and output.

Each step has a description of this transformation.

Each step has the amount of time needed for the transformation recorded as a linear formula of the form
  ax + b
where x is the requested amount factor,
and [a, b] are given in the step.

Example: burger buns bake for 30 minutes, regardless of their number: [a=0, b=30 min].
Example: each burger pattie takes 30 seconds to shape: [a=30 s, b=0].

## Produces (edge)
The relation produces exists from a step to an ingredient. It specifies how much of the ingredient is produced by the step by default.
The given amount is in the unit of the target ingredient.

## Consumes (edge)
The relation consumes exists from a step to an ingredient. It specifies how much of the ingredient is consumed by the step as a linear formula of the form:
  ax + b
where x is the requested amount factor,
and [a, b] are given in the step in the unit of the target ingredient.

# Roadmap

0. Talk to graph DB
1. Add ingredient and step nodes, with ability to CRUD them in the DB
2. Add consumes and produces edges, with ability to CRUD them in the DB
3. Add Servant REST API for ingredients, steps, and edges
4. Query an ingredient, get full subgraph as JSON
5. Query a certain amount of an ingredient, calculate / scale all the dependencies, do not divide undivisible ones (round up!)
6. Add basic support for recipes: set of ingredients + step choices
7. Add categories (tbd)

# Licence

Apache License, Version 2.0
