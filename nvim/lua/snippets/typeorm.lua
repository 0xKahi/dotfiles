local snippetUtils = require('utils.snippets')
local M = {}

M.entity = snippetUtils.basicSnippetHandler({
  snippet = [[
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
  ]],
  promptName = 'TypeormEntity',
  formatArgsFn = function(name)
    return { name }
  end,
})

M.repository = snippetUtils.basicSnippetHandler({
  snippet = [[
@CustomRepository(%s)
export class %sPlaythroughRepository extends StandardRepository<%s> {}
  ]],
  promptName = 'TypeormRepository',
  formatArgsFn = function(name)
    return snippetUtils.repeatArgsValue(name, 3)
  end,
})

return M
