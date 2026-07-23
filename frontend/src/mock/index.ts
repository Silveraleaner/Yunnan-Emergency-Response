import type { ViteDevServer } from 'vite'

const MOCK_USERS = [
  { userId: '1', username: 'admin', realName: '张管理', role: 'admin' },
  { userId: '2', username: 'commander', realName: '李指挥', role: 'commander' },
  { userId: '3', username: 'reporter', realName: '王上报', role: 'reporter' },
]

const MOCK_TOKEN = 'mock-jwt-token-2026'

const DISASTER_TYPES = ['earthquake', 'mudslide', 'flood', 'drought', 'landslide', 'fire', 'other']
const INCIDENT_LEVELS = ['I', 'II', 'III', 'IV']
const INCIDENT_STATUSES = ['pending', 'processing', 'completed']
const RESOURCE_TYPES = ['team', 'medical', 'vehicle', 'shelter']
const YUNNAN_REGIONS = ['昆明市', '曲靖市', '玉溪市', '保山市', '昭通市', '丽江市', '普洱市', '临沧市', '楚雄州', '红河州', '文山州', '西双版纳州', '大理州', '德宏州', '怒江州', '迪庆州']

function randomItem<T>(arr: T[]): T {
  return arr[Math.floor(Math.random() * arr.length)]
}

function randomInt(min: number, max: number): number {
  return Math.floor(Math.random() * (max - min + 1)) + min
}

let mockIncidents: Record<string, unknown>[] = []
let mockResources: Record<string, unknown>[] = []
let incidentIdCounter = 0

function initMockData(): void {
  for (let i = 0; i < 50; i++) {
    incidentIdCounter++
    mockIncidents.push({
      incidentId: String(incidentIdCounter),
      incidentName: `${randomItem(YUNNAN_REGIONS)}${randomItem(['地震', '泥石流', '洪涝', '干旱', '山体滑坡', '森林火灾'])}灾害${randomInt(1, 999)}`,
      disasterType: randomItem(DISASTER_TYPES),
      incidentLevel: randomItem(INCIDENT_LEVELS),
      occurTime: `2026-${String(randomInt(1, 7)).padStart(2, '0')}-${String(randomInt(1, 28)).padStart(2, '0')} ${String(randomInt(0, 23)).padStart(2, '0')}:${String(randomInt(0, 59)).padStart(2, '0')}:00`,
      location: `${randomItem(YUNNAN_REGIONS)}某区域`,
      description: `2026年某日，该地区发生自然灾害，造成一定程度的影响，需要紧急处置。`,
      status: randomItem(INCIDENT_STATUSES),
      attachments: [],
      imageUrls: i % 3 === 0 ? [`https://picsum.photos/seed/inc${i}/800/600`] : [],
      reporterId: String(randomInt(1, 3)),
      reportTime: `2026-${String(randomInt(1, 7)).padStart(2, '0')}-${String(randomInt(1, 28)).padStart(2, '0')} ${String(randomInt(0, 23)).padStart(2, '0')}:${String(randomInt(0, 59)).padStart(2, '0')}:00`,
    })
  }

  const resourceNames: Record<string, string[]> = {
    team: ['地震救援队', '山岳救援队', '水域救援队', '医疗救护队', '消防救援队'],
    medical: ['急救药品', '外科手术包', '消毒用品', '防护装备', '急救箱'],
    vehicle: ['救护车', '消防车', '工程抢险车', '物资运输车', '冲锋舟'],
    shelter: ['救灾帐篷', '临时安置房', '避难场所', '过渡安置板房'],
  }

  for (let i = 0; i < 100; i++) {
    const rType = randomItem(RESOURCE_TYPES)
    const quantity = randomInt(5, 500)
    const available = randomInt(0, quantity)
    mockResources.push({
      resourceId: String(i + 1),
      resourceName: `${randomItem(YUNNAN_REGIONS)}${randomItem(resourceNames[rType])}`,
      resourceType: rType,
      quantity,
      availableQuantity: available,
      status: available > 0 ? 'available' : 'dispatched',
      region: randomItem(YUNNAN_REGIONS),
    })
  }
}

initMockData()

function success(data: unknown) {
  return { code: 0, message: 'success', data }
}

function error(message: string) {
  return { code: 1, message, data: null }
}

function parseBody(req: any): Promise<any> {
  return new Promise((resolve) => {
    let body = ''
    req.on('data', (chunk: string) => { body += chunk })
    req.on('end', () => {
      try { resolve(JSON.parse(body)) } catch { resolve({}) }
    })
  })
}

export function mockPlugin() {
  return {
    name: 'vite-plugin-mock-api',
    configureServer(server: ViteDevServer) {
      server.middlewares.use(async (req: any, res: any, next: any) => {
        const url = req.url?.split('?')[0]
        if (!url?.startsWith('/api/')) return next()

        res.setHeader('Content-Type', 'application/json')

        if (url === '/api/login' && req.method === 'POST') {
          const body = await parseBody(req)
          const user = MOCK_USERS.find((u) => u.username === body.username)
          if (user) {
            res.end(JSON.stringify(success({ token: MOCK_TOKEN, userInfo: user })))
          } else {
            res.end(JSON.stringify(error('用户名或密码错误')))
          }
          return
        }

        const authHeader = req.headers?.authorization
        if (!authHeader || !authHeader.includes(MOCK_TOKEN)) {
          res.statusCode = 401
          res.end(JSON.stringify(error('未授权')))
          return
        }

        if (url === '/api/dashboard/overview') {
          res.end(JSON.stringify(success({
            todayCount: randomInt(2, 15),
            activeCount: randomInt(5, 30),
            pendingCount: randomInt(1, 10),
          })))
          return
        }

        if (url === '/api/dashboard/trend') {
          const dates = []
          const counts = []
          for (let i = 29; i >= 0; i--) {
            const d = new Date()
            d.setDate(d.getDate() - i)
            dates.push(`${d.getMonth() + 1}/${d.getDate()}`)
            counts.push(randomInt(0, 8))
          }
          res.end(JSON.stringify(success({ dates, counts })))
          return
        }

        if (url === '/api/dashboard/distribution') {
          res.end(JSON.stringify(success({
            types: DISASTER_TYPES,
            counts: DISASTER_TYPES.map(() => randomInt(3, 20)),
          })))
          return
        }

        if (url === '/api/dashboard/screen') {
          res.end(JSON.stringify(success({
            statistics: { todayCount: randomInt(2, 15), activeCount: randomInt(5, 30), pendingCount: randomInt(1, 10) },
            incidents: mockIncidents.slice(0, 10),
            resources: mockResources.slice(0, 20),
          })))
          return
        }

        if (url === '/api/incident/list') {
          const params = new URL(req.url, 'http://localhost').searchParams
          const page = Number(params.get('page') || 1)
          const size = Number(params.get('size') || 20)
          const start = (page - 1) * size
          res.end(JSON.stringify(success({
            total: mockIncidents.length,
            list: mockIncidents.slice(start, start + size),
          })))
          return
        }

        if (url === '/api/incident/detail') {
          const id = new URL(req.url, 'http://localhost').searchParams.get('incidentId')
          const incident = mockIncidents.find((i) => i.incidentId === id)
          res.end(JSON.stringify(success(incident || null)))
          return
        }

        if (url === '/api/incident/report' && req.method === 'POST') {
          incidentIdCounter++
          const newIncident = {
            incidentId: String(incidentIdCounter),
            incidentName: '新上报灾情事件',
            disasterType: 'earthquake',
            incidentLevel: 'III',
            occurTime: new Date().toISOString(),
            location: '云南省昆明市',
            description: '新上报的灾情事件',
            status: 'pending',
            attachments: [],
            imageUrls: [],
            reporterId: '1',
            reportTime: new Date().toISOString(),
          }
          mockIncidents.unshift(newIncident)
          res.end(JSON.stringify(success({ incidentId: newIncident.incidentId, imageUrls: [] })))
          return
        }

        if (url === '/api/resource/list') {
          res.end(JSON.stringify(success(mockResources)))
          return
        }

        if (url === '/api/resource/dispatch' && req.method === 'POST') {
          res.end(JSON.stringify(success(null)))
          return
        }

        if (url === '/api/plan/list') {
          res.end(JSON.stringify(success([
            { planId: '1', incidentId: '1', planTitle: '地震应急方案-初版', planContent: '<h3>一、灾情概述</h3><p>本次地震发生在云南省某地区，震级5.2级，需紧急响应。</p><h3>二、响应措施</h3><p>1. 立即启动Ⅲ级应急响应<br/>2. 组织救援队伍赶赴现场<br/>3. 设置临时安置点<br/>4. 开展伤员救治</p><h3>三、资源调配</h3><p>调配救援队伍3支、医疗物资若干、运输车辆10台。</p>', generateTime: '2026-07-20 10:30:00', status: 'approved' },
            { planId: '2', incidentId: '1', planTitle: '地震应急方案-修订版', planContent: '<h3>一、灾情更新</h3><p>根据最新灾情评估，调整响应级别为Ⅱ级。</p><h3>二、调整措施</h3><p>1. 提升应急响应级别至Ⅱ级<br/>2. 增派救援力量<br/>3. 扩大疏散范围</p>', generateTime: '2026-07-21 14:00:00', status: 'draft' },
          ])))
          return
        }

        if (url === '/api/plan/generate' && req.method === 'POST') {
          setTimeout(() => {
            const newPlan = {
              planId: String(Date.now()),
              incidentId: '1',
              planTitle: `AI生成方案-${new Date().toLocaleString()}`,
              planContent: '<h3>一、灾情分析</h3><p>基于AI分析，本次灾害影响范围较广，建议采取以下措施。</p><h3>二、应急响应</h3><p>1. 启动应急响应机制<br/>2. 组织人员疏散<br/>3. 调配应急资源</p><h3>三、后续跟进</h3><p>持续监测灾情变化，及时调整响应策略。</p>',
              generateTime: new Date().toISOString(),
              status: 'draft',
            }
            res.end(JSON.stringify(success({ planId: newPlan.planId })))
          }, 2000)
          return
        }

        if (url === '/api/plan/detail') {
          res.end(JSON.stringify(success({
            planId: '1', incidentId: '1', planTitle: '地震应急方案',
            planContent: '<h3>一、灾情概述</h3><p>本次地震发生在云南省某地区，震级5.2级。</p><h3>二、响应措施</h3><p>1. 启动应急响应<br/>2. 组织救援<br/>3. 设置安置点</p>',
            generateTime: '2026-07-20 10:30:00', status: 'approved',
          })))
          return
        }

        next()
      })
    },
  }
}