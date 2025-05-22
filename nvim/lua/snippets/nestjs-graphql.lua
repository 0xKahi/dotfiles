local snippetUtils = require('snippets.libs.util')
local M = {}

local graphQlInputSnippet = [[
import { Field, InputType } from '@nestjs/graphql';

@InputType()
export class %sInput {
  @Field(() => String)
  test: string;
}
]]

M[' Input'] = snippetUtils.basicSnippetHandler({
  promptName = 'GraphQlInput',
  snippet = graphQlInputSnippet,
  formatArgsFn = function(name)
    return { name }
  end,
})

local graphQlArgsSnippet = [[
import { ArgsType, Field } from '@nestjs/graphql';

@ArgsType()
export class %sArgs {
  @Field(() => String)
  test: string;
}
]]

M[' Args'] = snippetUtils.basicSnippetHandler({
  promptName = 'GraphQlArgs',
  snippet = graphQlArgsSnippet,
  formatArgsFn = function(name)
    return { name }
  end,
})

local graphQlModelSnippet = [[
import { Field, ObjectType } from '@nestjs/graphql';

@ObjectType()
export class %sModel {
  @Field(() => String)
  test: string;
}
]]

M[' Model'] = snippetUtils.basicSnippetHandler({
  promptName = 'GraphQlModel',
  snippet = graphQlModelSnippet,
  formatArgsFn = function(name)
    return { name }
  end,
})

return M
