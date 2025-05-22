local snippetUtils = require('snippets.libs.util')

local M = {}

local serviceSnippet = [[
import { Injectable } from '@nestjs/common';

@Injectable()
export class %sService {
  constructor(
    // private readonly 

  ) {}
}
]]

M.service = snippetUtils.basicSnippetHandler({
  promptName = 'NestJsService',
  snippet = serviceSnippet,
  formatArgsFn = function(name)
    return { name }
  end,
})

local resolverSnippet = [[
import { Args, Mutation, Query, Resolver } from '@nestjs/graphql';

@Resolver()
export class %sResolver {
  constructor(
    private readonly %sService: %sService,

  ) {}

  @Query(() => Boolean)
  async testQuery(): Promise<boolean> {
    return true;
  }

  @Mutation(() => Boolean)
  async testMutation(): Promise<boolean> {
    return true;
  }
}
]]

M.resolver = snippetUtils.basicSnippetHandler({
  promptName = 'NestJsResolver',
  snippet = resolverSnippet,
  formatArgsFn = function(name)
    return { name, require('utils.fmt').toCamelCase(name), name }
  end,
})

local moduleSnippet = [[
import { Module } from '@nestjs/common';

@Module({
  imports: [],
  providers: [],
  controllers: [],
  exports: []
})
export class %sModule {}
]]

M.module = snippetUtils.basicSnippetHandler({
  promptName = 'NestJsModule',
  snippet = moduleSnippet,
  formatArgsFn = function(name)
    return { name }
  end,
})

return M
