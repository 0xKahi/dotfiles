local snippetUtils = require('snippets.libs.util')
local M = {}

local entitySnippet = [[
import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export class %s {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  test: string;

  @CreateDateColumn({ type: 'timestamptz' })
  createdAt: Date;
}
]]

M.entity = snippetUtils.basicSnippetHandler({
  snippet = entitySnippet,
  promptName = 'TypeormEntity',
  formatArgsFn = function(name)
    return { name }
  end,
})

local entityGraphqlSnippet = [[
import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn } from 'typeorm';
import { Field, GraphQLISODateTime, ID, ObjectType } from '@nestjs/graphql';

@Entity()
@ObjectType()
export class %s {
  @Field(() => ID)
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  test: string;

  @Field(() => GraphQLISODateTime)
  @CreateDateColumn({ type: 'timestamptz' })
  createdAt: Date;
}
]]

M[' entity'] = snippetUtils.basicSnippetHandler({
  snippet = entityGraphqlSnippet,
  promptName = 'TypeormGraphqlEntity',
  formatArgsFn = function(name)
    return { name }
  end,
})

local repositorySnippet = [[
@CustomRepository(%s)
export class %sRepository extends StandardRepository<%s> {}
]]
M.repository = snippetUtils.basicSnippetHandler({
  snippet = repositorySnippet,
  promptName = 'TypeormRepository',
  formatArgsFn = function(name)
    return snippetUtils.repeatArgsValue(name, 3)
  end,
})

return M
