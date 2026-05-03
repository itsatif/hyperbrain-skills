# Backend Knowledge Base - jt-api-v2

**Author:** Atif Salafi <atif8486@gmail.com>
**Organization:** DeJoule / Smart Joules
**Purpose:** Complete backend API knowledge for AI-assisted development
**Version:** 1.0.0
**Last Updated:** 2026-05-03

---

## 🏗️ System Overview

### jt-api-v2 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    jt-api-v2 Backend API                    │
└─────────────────────────────────────────────────────────────┘

                    ┌──────────────────┐
                    │  Client Request  │
                    │  (JouleTRACK,    │
                    │   Mobile Apps)   │
                    └────────┬─────────┘
                             │ HTTPS
                    ┌────────▼─────────┐
                    │   Express.js     │
                    │   HTTP Server    │
                    └────────┬─────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
┌───────▼────────┐  ┌───────▼────────┐  ┌───────▼────────┐
│  Controllers  │  │  Middlewares   │  │  Routes       │
│  (Request     │  │  (Auth,        │  │  (Endpoint    │
│   Handling)   │  │   Validation,  │  │   Definition) │
└───────┬────────┘  └───────┬────────┘  └───────┬────────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
                    ┌────────▼─────────┐
                    │    Services      │
                    │  (Business       │
                    │   Logic)         │
                    └────────┬─────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
┌───────▼────────┐  ┌───────▼────────┐  ┌───────▼────────┐
│  Repositories │  │  Transformers  │  │  Validators    │
│  (Data Access) │  │  (DTO↔Domain)   │  │  (Schema       │
└───────┬────────┘  └───────┬────────┘  └───────┬────────┘
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
┌───────▼────────┐  ┌───────▼────────┐  ┌───────▼────────┐
│  PostgreSQL   │  │  InfluxDB      │  │  Redis         │
│  (Metadata)   │  │  (Time-Series) │  │  (Cache)       │
└────────────────┘  └────────────────┘  └────────────────┘
```

---

## 📦 Technology Stack

### Core Framework
- **Runtime:** Node.js 18.x, 20.x
- **Framework:** Express.js 4.18.x
- **Language:** TypeScript 5.x (strict mode)
- **Package Manager:** npm / yarn

### Key Dependencies
```json
{
  "express": "^4.18.0",
  "@types/express": "^4.17.17",
  "typescript": "^5.0.0",
  "pg": "^8.11.0",
  "node-influx": "^5.9.0",
  "redis": "^4.6.0",
  "ioredis": "^5.3.0",
  "joi": "^17.9.0",
  "jsonwebtoken": "^9.0.0",
  "bcrypt": "^5.1.0",
  "winston": "^3.8.0",
  "dotenv": "^16.0.0"
}
```

---

## 🔌 API Architecture

### Route Organization

```
src/
├── controllers/           # Request handlers
│   ├── auth.controller.ts
│   ├── dashboard.controller.ts
│   ├── device.controller.ts
│   └── recipe.controller.ts
├── services/              # Business logic
│   ├── auth.service.ts
│   ├── dashboard.service.ts
│   ├── device.service.ts
│   └── recipe.service.ts
├── repositories/          # Data access layer
│   ├── site.repository.ts
│   ├── device.repository.ts
│   └── user.repository.ts
├── middlewares/           # Express middleware
│   ├── auth.middleware.ts
│   ├── validation.middleware.ts
│   ├── error.middleware.ts
│   └── rate-limit.middleware.ts
├── validators/           # Joi validation schemas
│   ├── auth.validator.ts
│   ├── device.validator.ts
│   └── recipe.validator.ts
├── transformers/         # DTO → Domain → ViewModel
│   ├── device.transformer.ts
│   └── consumption.transformer.ts
├── models/               # Database models
│   ├── site.model.ts
│   ├── device.model.ts
│   └── user.model.ts
├── utils/                # Utilities
│   ├── logger.util.ts
│   ├── error.util.ts
│   └── config.util.ts
├── config/               # Configuration
│   ├── database.config.ts
│   ├── redis.config.ts
│   └── influx.config.ts
├── types/                # TypeScript types
│   ├── auth.types.ts
│   ├── device.types.ts
│   └── api.types.ts
└── app.ts                # Express app setup
```

---

## 🔐 Authentication & Authorization

### JWT Authentication Flow

```typescript
/**
 * Login flow
 */
POST /api/auth/login
1. Validate email/password (Joi schema)
2. Query PostgreSQL for user
3. Compare password (bcrypt.compare)
4. Generate JWT (sign with SECRET)
5. Store session in Redis (key: session_<token>)
6. Return { token, user }

/**
 * Request authentication
 */
GET /api/protected/*
Headers: Authorization: Bearer <token>
1. Extract JWT token
2. Verify signature (jwt.verify)
3. Check Redis session exists
4. Check token not expired
5. Attach user to req.user
6. Allow/deny request
```

### Middleware Implementation

```typescript
/**
 * Authentication middleware
 */
export async function authMiddleware(
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> {
  try {
    // 1. Get token from header
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) {
      throw new UnauthorizedError('No token provided');
    }

    const token = authHeader.substring(7);

    // 2. Verify JWT
    const decoded = jwt.verify(token, process.env.JWT_SECRET) as JwtPayload;

    // 3. Check Redis session
    const session = await redisClient.get(`session_${token}`);
    if (!session) {
      throw new UnauthorizedError('Session expired');
    }

    // 4. Attach user to request
    req.user = JSON.parse(session);
    next();
  } catch (error) {
    next(error);
  }
}
```

---

## 📊 Database Interactions

### PostgreSQL (Metadata)

```typescript
/**
 * Repository pattern for PostgreSQL
 */
export class DeviceRepository {
  constructor(private pool: Pool) {}

  /**
   * Find device by ID
   */
  async findById(deviceId: string): Promise<Device | null> {
    const query = `
      SELECT id, site_id, name, type, properties
      FROM devices
      WHERE id = $1
    `;
    const result = await this.pool.query(query, [deviceId]);
    return result.rows[0] || null;
  }

  /**
   * Find devices by site
   */
  async findBySite(siteId: string): Promise<Device[]> {
    const query = `
      SELECT id, site_id, name, type, properties
      FROM devices
      WHERE site_id = $1
      ORDER BY name ASC
    `;
    const result = await this.pool.query(query, [siteId]);
    return result.rows;
  }

  /**
   * Create device
   */
  async create(data: CreateDeviceDto): Promise<Device> {
    const query = `
      INSERT INTO devices (site_id, name, type, properties)
      VALUES ($1, $2, $3, $4)
      RETURNING *
    `;
    const result = await this.pool.query(query, [
      data.siteId,
      data.name,
      data.type,
      JSON.stringify(data.properties)
    ]);
    return result.rows[0];
  }
}
```

### InfluxDB (Time-Series)

```typescript
/**
 * InfluxDB query service
 */
export class InfluxService {
  private client: InfluxDB;

  constructor() {
    this.client = new InfluxDB.InfluxDB(
      process.env.INFLUX_URL,
      process.env.INFLUX_TOKEN,
      process.env.INFLUX_ORG
    );
  }

  /**
   * Query device telemetry
   */
  async getTelemetry(
    siteId: string,
    deviceId: string,
    start: Date,
    end: Date
  ): Promise<TelemetryPoint[]> {
    const query = `
      from(bucket: "device_component/autogen")
        |> range(start: ${start.toISOString()}, stop: ${end.toISOString()})
        |> filter(fn: (r) => r._measurement == "components")
        |> filter(fn: (r) => r.siteId == "${siteId}")
        |> filter(fn: (r) => r.id == "${deviceId}")
        |> pivot(rowKey:["_time"], columnKey: ["_field"], valueColumn: "_value")
    `;

    const result = await this.client.queryRows(query, 'org');
    return this.parseResult(result);
  }

  /**
   * Get current asset state
   */
  async getAssetState(siteId: string): Promise<AssetState[]> {
    const query = `
      from(bucket: "device_component/autogen")
        |> range(start: -5m)
        |> filter(fn: (r) => r._measurement == "asset_state")
        |> filter(fn: (r) => r.siteId == "${siteId}")
        |> last()
    `;

    const result = await this.client.queryRows(query, 'org');
    return this.parseResult(result);
  }
}
```

### Redis (Cache)

```typescript
/**
 * Cache service using Redis
 */
export class CacheService {
  constructor(private redis: Redis) {}

  /**
   * Get cached value
   */
  async get<T>(key: string): Promise<T | null> {
    const value = await this.redis.get(key);
    return value ? JSON.parse(value) : null;
  }

  /**
   * Set cache value with TTL
   */
  async set(key: string, value: any, ttl: number = 3600): Promise<void> {
    await this.redis.setex(key, ttl, JSON.stringify(value));
  }

  /**
   * Invalidate cache
   */
  async del(key: string): Promise<void> {
    await this.redis.del(key);
  }

  /**
   * Get or Set (cache aside pattern)
   */
  async getOrSet<T>(
    key: string,
    factory: () => Promise<T>,
    ttl: number = 3600
  ): Promise<T> {
    // Try cache first
    const cached = await this.get<T>(key);
    if (cached) return cached;

    // Cache miss - fetch data
    const value = await factory();

    // Set in cache
    await this.set(key, value, ttl);

    return value;
  }
}
```

---

## 🎯 Service Layer Patterns

### Dashboard Service

```typescript
/**
 * Dashboard service - business logic
 */
@Injectable()
export class DashboardService {
  constructor(
    private deviceRepo: DeviceRepository,
    private influxService: InfluxService,
    private cacheService: CacheService,
    private transformer: DashboardTransformer
  ) {}

  /**
   * Get energy consumption for site
   */
  async getConsumption(
    siteId: string,
    start: Date,
    end: Date
  ): Promise<ConsumptionViewModel> {
    // 1. Try cache first
    const cacheKey = `consumption:${siteId}:${start.getTime()}:${end.getTime()}`;
    const cached = await this.cacheService.get<ConsumptionViewModel>(cacheKey);
    if (cached) return cached;

    // 2. Fetch devices for site
    const devices = await this.deviceRepo.findBySite(siteId);

    // 3. Fetch telemetry from InfluxDB
    const telemetry = await this.influxService.getTelemetry(
      siteId,
      devices.map(d => d.id).join('|'),
      start,
      end
    );

    // 4. Transform to domain model
    const domain = this.transformer.toDomain({ devices, telemetry });

    // 5. Transform to view model
    const viewModel = this.transformer.toViewModel(domain);

    // 6. Cache for 5 minutes
    await this.cacheService.set(cacheKey, viewModel, 300);

    return viewModel;
  }
}
```

---

## 🔄 Data Transformation Pipeline

### DTO → Domain → ViewModel

```typescript
/**
 * Device transformer
 */
@Injectable()
export class DeviceTransformer {
  /**
   * Transform DTO to Domain Model
   */
  toDto(domain: DeviceDomain): DeviceDto {
    return {
      id: domain.id,
      site_id: domain.siteId,
      name: domain.name,
      type: domain.type,
      properties: JSON.stringify(domain.properties),
      created_at: domain.createdAt,
    };
  }

  /**
   * Transform DTO to Domain Model
   */
  toDomain(dto: DeviceDto): DeviceDomain {
    return {
      id: dto.id,
      siteId: dto.site_id,
      name: dto.name,
      type: dto.type,
      properties: JSON.parse(dto.properties),
      createdAt: new Date(dto.created_at),
    };
  }

  /**
   * Transform Domain to ViewModel
   */
  toViewModel(domain: DeviceDomain): DeviceViewModel {
    return {
      id: domain.id,
      name: domain.name,
      type: this.formatDeviceType(domain.type),
      capacity: this.properties.capacity,
      status: this.deriveStatus(domain.properties),
      lastReading: domain.properties.lastReading || null,
    };
  }

  private formatDeviceType(type: string): string {
    return type.split('_').map(word =>
      word.charAt(0).toUpperCase() + word.slice(1)
    ).join(' ');
  }

  private deriveStatus(properties: any): string {
    if (properties.isOnline === false) return 'Offline';
    if (properties.hasAlarm) return 'Alarm';
    return 'Online';
  }
}
```

---

## 🚨 Error Handling

### Custom Error Classes

```typescript
/**
 * Base API error
 */
export class ApiError extends Error {
  constructor(
    public statusCode: number,
    public code: string,
    message: string
  ) {
    super(message);
    this.name = this.constructor.name;
  }
}

/**
 * Validation error
 */
export class ValidationError extends ApiError {
  constructor(message: string) {
    super(400, 'VALIDATION_ERROR', message);
  }
}

/**
 * Not found error
 */
export class NotFoundError extends ApiError {
  constructor(resource: string, id: string) {
    super(404, 'NOT_FOUND', `${resource} with ID ${id} not found`);
  }
}

/**
 * Unauthorized error
 */
export class UnauthorizedError extends ApiError {
  constructor(message: string = 'Unauthorized') {
    super(401, 'UNAUTHORIZED', message);
  }
}
```

### Global Error Handler

```typescript
/**
 * Global error handling middleware
 */
export function errorHandler(
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
): void {
  // Log error
  logger.error('API Error:', {
    message: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
  });

  // Handle known errors
  if (err instanceof ApiError) {
    res.status(err.statusCode).json({
      success: false,
      error: {
        code: err.code,
        message: err.message,
      },
    });
    return;
  }

  // Handle unknown errors
  res.status(500).json({
    success: false,
    error: {
      code: 'INTERNAL_SERVER_ERROR',
      message: 'An unexpected error occurred',
    },
  });
}
```

---

## 🧪 Testing Patterns

### Unit Test (Service)

```typescript
describe('DashboardService', () => {
  let service: DashboardService;
  let deviceRepoMock: jest.Mocked<DeviceRepository>;
  let influxServiceMock: jest.Mocked<InfluxService>;
  let cacheServiceMock: jest.Mocked<CacheService>;

  beforeEach(() => {
    deviceRepoMock = {
      findBySite: jest.fn(),
    } as any;

    influxServiceMock = {
      getTelemetry: jest.fn(),
    } as any;

    cacheServiceMock = {
      get: jest.fn(),
      set: jest.fn(),
    } as any;

    service = new DashboardService(
      deviceRepoMock,
      influxServiceMock,
      cacheServiceMock,
      new DeviceTransformer()
    );
  });

  describe('getConsumption', () => {
    it('should return cached data if available', async () => {
      // Arrange
      const cached = { total: 100 };
      cacheServiceMock.get.mockResolvedValue(cached);

      // Act
      const result = await service.getConsumption('site-1', new Date(), new Date());

      // Assert
      expect(result).toEqual(cached);
      expect(deviceRepoMock.findBySite).not.toHaveBeenCalled();
    });

    it('should fetch and cache data if not cached', async () => {
      // Arrange
      const devices = [{ id: 'device-1' }];
      const telemetry = [{ value: 100 }];
      cacheServiceMock.get.mockResolvedValue(null);
      deviceRepoMock.findBySite.mockResolvedValue(devices);
      influxServiceMock.getTelemetry.mockResolvedValue(telemetry);

      // Act
      const result = await service.getConsumption('site-1', new Date(), new Date());

      // Assert
      expect(deviceRepoMock.findBySite).toHaveBeenCalledWith('site-1');
      expect(influxServiceMock.getTelemetry).toHaveBeenCalled();
      expect(cacheServiceMock.set).toHaveBeenCalled();
    });
  });
});
```

### Integration Test (API)

```typescript
describe('Dashboard API', () => {
  let app: Express;
  let db: Pool;

  beforeAll(async () => {
    // Setup test database
    db = await createTestPool();
    app = createApp(db);
  });

  afterAll(async () => {
    await db.end();
  });

  describe('GET /api/dashboard/:siteId/consumption', () => {
    it('should return consumption data', async () => {
      // Arrange
      await seedTestData(db);

      // Act
      const response = await request(app)
        .get('/api/dashboard/site-1/consumption')
        .set('Authorization', `Bearer ${getTestToken()}`)
        .expect(200);

      // Assert
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveProperty('total');
    });

    it('should return 401 without auth', async () => {
      // Act
      await request(app)
        .get('/api/dashboard/site-1/consumption')
        .expect(401);
    });
  });
});
```

---

## 🚀 Deployment

### Docker Configuration

```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine AS runtime
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
EXPOSE 3000
CMD ["node", "dist/main.js"]
```

### Environment Variables

```bash
# Database
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=jouletrack
POSTGRES_USER=jouletrack
POSTGRES_PASSWORD=secret

# InfluxDB
INFLUX_URL=https://influxdb.example.com
INFLUX_TOKEN=secret-token
INFLUX_ORG=jouletrack

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=secret

# JWT
JWT_SECRET=your-secret-key
JWT_EXPIRES_IN=7d

# Server
PORT=3000
NODE_ENV=production
```

---

## 📚 Key Services Reference

### Auth Service
- **Location:** `src/services/auth.service.ts`
- **Purpose:** Authentication and authorization
- **Methods:** `login()`, `logout()`, `validateToken()`, `refreshToken()`

### Dashboard Service
- **Location:** `src/services/dashboard.service.ts`
- **Purpose:** Dashboard data aggregation
- **Methods:** `getConsumption()`, `getEfficiency()`, `getTrends()`

### Device Service
- **Location:** `src/services/device.service.ts`
- **Purpose:** Device management and commands
- **Methods:** `getAll()`, `getById()`, `sendCommand()`, `getTelemetry()`

### Recipe Service
- **Location:** `src/services/recipe.service.ts`
- **Purpose:** Optimization recipe execution
- **Methods:** `getAll()`, `execute()`, `getStatus()`, `abort()`

---

**This knowledge base provides complete backend context for AI-assisted API development.**
