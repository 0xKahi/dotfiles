local snippetUtils = require('snippets.libs.util')
local M = {}

local jestSnippet = [[
import { INestApplication } from '@nestjs/common';
import { MainDatasourceService } from '@shuffle/common/modules/main-datasource/main-datasource.service';
import { PresetAdminRole } from 'test/setup/storage-reset';
import { APP, AppStarter } from 'test/utils/app-starter';
import { CreatedAdmin, createAdmin } from 'test/utils/create-admin';
import { CreatedUser, createUser } from 'test/utils/create-user';

describe('%s (e2e)', () => {
  let app: INestApplication;
  let adminApp: INestApplication;

  let admin: CreatedAdmin;
  let user: CreatedUser;
  let mainDatasourceService: MainDatasourceService;

  const appStarter = new AppStarter();

  beforeAll(async () => {
    app = await appStarter.startApp(APP.API, {});
    
    adminApp = await appStarter.startApp(APP.ADMIN, {});
    mainDatasourceService = app.get(MainDatasourceService);

    admin = await createAdmin(adminApp, {
      role: PresetAdminRole.SUPERADMIN,
    });
    user = await createUser(app);
  });

  beforeEach(async () => {
    // some code
  });

  afterEach(async () => {
    // some code
  });

  it('%s first test', async () => {
    const x = true

    expect(x).toBeFalsy();
  });
});
]]

M[' jest (e2e)'] = snippetUtils.basicSnippetHandler({
  snippet = jestSnippet,
  promptName = 'Jest Test Name',
  formatArgsFn = function(name)
    return snippetUtils.repeatArgsValue(name, 2)
  end,
})

return M
