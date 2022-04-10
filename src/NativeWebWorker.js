/**
 * @flow strict-local
 */

import type { TurboModule } from 'react-native/Libraries/TurboModule/RCTExport';
import * as TurboModuleRegistry from 'react-native/Libraries/TurboModule/TurboModuleRegistry';

export interface Spec extends TurboModule {
  startThread: (threadId: number, name: string) => void;
  stopThread: (threadId: number) => void;
  postMessage: (threadId: number, message: string) => void;
  // RCTEventEmitter
  addListener: (eventName: string) => void;
  removeListeners: (count: number) => void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('WebWorker');
